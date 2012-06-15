class MeetingsController < InheritedResources::Base

  def accept
    @meeting = Meeting.find(params[:id])
    @meetup = Meetup.find(@meeting.meetup_id)
    if !@meeting.accepted_already? and @meeting.update_attributes(:accepted => true, :accepted_at => Time.now) and @meeting.save
      flash[:notice] = t("flash.meetup.accept.notice")
    else
      flash[:error] = t("flash.meetup.accept.error")
    end
    redirect_to @meetup
  end

end
