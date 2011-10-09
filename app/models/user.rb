# require 'digest/sha1'

class User < ActiveRecord::Base

  # :token_authenticatable, :lockable, :timeoutable, :confirmable and :activatable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  
  before_create :build_user


  # ajaxful_rater # has_many :rates
  acts_as_taggable_on :interests, :wishs, :skills, :aims
  acts_as_tagger
  
  # has_many
  has_many :events
  accepts_nested_attributes_for :events, :allow_destroy => true, :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }
  has_many :accounts
  has_many :friendships
  has_many :friends, :through => :friendships, :conditions => "accepted_at is NOT NULL"
  has_many :inverse_friendships, :class_name => "Friendship", :foreign_key => "friend_id"
  has_many :inverse_friends, :through => :inverse_friendships, :source => :user, :conditions => "accepted_at is NOT NULL"
  has_many :sent_messages, :class_name => "Message", :foreign_key => "author_id"
  has_many :received_messages, :class_name => "MessageCopy", :foreign_key => "recipient_id"
  has_many :folders
  has_many :items
  has_many :items_needed,
           :through => 'Items',
           :conditions => {:need => true}
  has_many :items_offered,
           :class_name => 'Item',
           :conditions => {:need => false}
  has_many :items_taken,
           :source => :item,
           :through => :accounts,
           :foreign_key => "user_id",
           :conditions => {:need => false}
  has_many :items_given,
           :source => :item,
           :through => :accounts,
           :foreign_key => "user_id",
           :conditions => {:need => true}                     
  has_many :images, :as => :imageable, :dependent => :destroy
  accepts_nested_attributes_for :images, :allow_destroy => true, :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }
  has_many :pings,
           :source => "Ping",
           :foreign_key => :user_id
  has_many :transfers, :class_name => "Transfer", :foreign_key => "user_id"
  has_many :comments, :as => :commentable
  has_many :meetings
  has_many :meetups, :through => :meetings
    
  # has_one
  #has_one :avatar, :as => :imageable
  has_one :location, :as => :locatable
  accepts_nested_attributes_for :location, :reject_if => lambda { |a| a[:address].blank? }, :allow_destroy => true
  has_one :userdetails
  accepts_nested_attributes_for :userdetails, :allow_destroy => true
  

  # deletagions
  delegate :given, :taken, :to => :accounts
  
  
  # Virtual attribute for the unencrypted password
  attr_accessor :password

  validates_presence_of     :login, :email
  validates_presence_of     :password,                   :if => :password_required?
  validates_presence_of     :password_confirmation,      :if => :password_required?
  validates_length_of       :password, :within => 4..40, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?
  validates_length_of       :login,    :within => 3..40
  validates_length_of       :email,    :within => 3..100
  validates_uniqueness_of   :login, :email, :case_sensitive => false
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message => :invalid
   
  before_save :encrypt_password
  before_create :make_activation_code 
  
  attr_accessible :login, :email, :password, :password_confirmation, 
                  :interest_list, :wish_list, :aim_list, :skill_list, 
                  :userdetails_attributes, :images, :images_attributes, 
                  :location_attributes, :meeting_ids,
                  :occupation, :company, :birthdate, :lastname, :firstname
                  
  
  # autocomplete for aims, wishes, interests and skills
  def aim_list_name
    self.aim_list if aim_list
  end
  
  def aim_list_name=(name)
    self.aim_list = Tag.find_or_create_by_name(name) unless name.blank?
  end
  
  # mailbox
  def inbox
    folders.find_by_title("Inbox")
  end

  def build_user
    folders.build(:title => "Inbox") # message folder
  end

  # Activates the user in the database.
  def activate
    @activated = true
    self.activated_at = Time.now.utc
    self.activation_code = nil
    save(false)
  end

  def active?
    # the existence of an activation code means they have not activated yet
    activation_code.nil?
  end

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    u = find :first, :conditions => ['login = ? and activated_at IS NOT NULL', login] # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    remember_me_for 2.weeks
  end

  def remember_me_for(time)
    remember_me_until time.from_now.utc
  end

  def remember_me_until(time)
    self.remember_token_expires_at = time
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end

  # Returns true if the user has just been activated.
  def recently_activated?
    @activated
  end

  protected
  
  def self.random
    if (c = count) != 0
      find(:first, :offset =>rand(c))
    end
  end
    
  #search
  def self.prepare_search_scopes(params = {})
    scope = self.search(params[:search])   
    order = params[:search][:order]
    if order
       parts = order.split("_")
       direction = parts[0] == "ascend" ? "ASC" : "DESC"
       if parts[3]
         scope.order = "#{parts[2]}_#{parts[3]} #{direction}"
       elsif parts[2] == "location"
         scope.find(:all, :origin => [@user_location.ll])
       elsif parts[2]
        scope.order = "#{parts[2]} #{direction}"
       end
    end
    return scope
  end
  
  # before filter 
  def encrypt_password
    return if password.blank?
    self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
    self.crypted_password = encrypt(password)
  end
    
  def password_required?
    crypted_password.blank? || !password.blank?
  end
  
  def make_activation_code
    self.activation_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
  end
    
end