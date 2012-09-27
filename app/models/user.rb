# encoding: utf-8
class User < ActiveRecord::Base

  attr_accessible :login, :email, :username, :password, :password_confirmation,
                  :interest_list, :wish_list, :aim_list, :skill_list,
                  :userdetails_attributes, :images, :images_attributes,
                  :location_attributes, :meeting_ids, :meetup_ids,
                  :occupation, :company, :birthdate, :lastname, :firstname,
                  :remember_me,
                  :aim_tokens, :skill_tokens, :interest_tokens, :wish_tokens


  extend FriendlyId
  friendly_id :login

  # :token_authenticatable, :lockable, :timeoutable, :encryptable, :confirmable, :encryptor => :restful_authentication_sha1 and :activatable
  devise :database_authenticatable, :registerable, :rememberable, :recoverable #, :encryptable, :encryptor => :bcrypt, :authentication_keys => [:username], :rpx_connectable, :recoverable, :trackable, :confirmable, :recoverable, :trackable, :validatable

  after_validation :build_user

  # ajaxful_rater # has_many :rates
  acts_as_taggable_on :interests, :wishs, :aims
  acts_as_tagger
  
  acts_as_follower
  acts_as_followable

  has_associated_audits
  acts_as_audited #:associated_with => :meetup, :except => [:password]
  
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
  accepts_nested_attributes_for :images, :allow_destroy => true, :reject_if => lambda { |a| a[:image].blank? }
  has_many :pings,
           :source => "Ping",
           :foreign_key => :user_id
  has_many :transfers, :class_name => "Transfer", :foreign_key => "user_id"
  has_many :comments, :as => :commentable
  has_many :meetings, :dependent => :destroy
  # belongs_to :meetups
  has_many :meetups, :through => :meetings, :foreign_key => "owner_id", :dependent => :destroy, :include => [:events] #, :order => "events.from desc"
  # has_many :meetups, :through => :meetings, :dependent => :destroy
  # has_one :meetup, :through => :meetings
  # belongs_to :groups
  has_many :groups
  # has_many :groupings, :dependent => :destroy
    
  # has_one
  has_one :custom, :as => :customable
  has_one :location, :as => :locatable
  accepts_nested_attributes_for :location, :reject_if => lambda { |a| a[:address].blank? }, :allow_destroy => true
  has_one :userdetails
  accepts_nested_attributes_for :userdetails, :allow_destroy => true
  

  # deletagions
  delegate :given, :taken, :to => :accounts
  
  


  validates_presence_of     :login, :email
  validates_presence_of     :password, :if => :password                   
  validates_presence_of     :password_confirmation, :if => :password      
  validates_length_of       :password, :within => 4..40, :if => :password
  validates_confirmation_of :password, :if => :password                 
  validates_length_of       :login,    :within => 3..40
  validates_length_of       :email,    :within => 3..100
  validates_uniqueness_of   :login, :email, :case_sensitive => false
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message => :invalid
  
  # Virtual attribute for the unencrypted password
  # attr_accessor :password
   
  # Virtual attribute for authenticating by either username or email
  # This is in addition to a real persisted field like 'username'
  attr_accessor :username

  attr_reader     :aim_tokens, :skill_tokens, :interest_tokens, :wish_tokens

  def exists?(id)
    not User.find_by_id(id).nil?
  end

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
    # message folder
    self.folder = Folder.new(:title => "Inbox") if not Folder.exists?(self)
    self.custom = Custom.new # customization for user
    self.location = Location.new
  end

  def pinged?(resource)
    Ping.new(
      :pingable_type => resource.class.to_s,
      :pingable_id => resource.id,
      :user_id => self.id
    ).exists?
  end
  

  protected
  
  def self.find_for_database_authentication(warden_conditions)
     conditions = warden_conditions.dup
     username = conditions.delete(:username)
     where(conditions).where(["lower(login) = :value OR lower(email) = :value", { :value => username.downcase }]).first
   end
  
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
    
end
