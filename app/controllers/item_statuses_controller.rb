class ItemStatusesController < ApplicationController
  # GET /item_statuses
  # GET /item_statuses.xml
  def index
    @item_statuses = ItemStatus.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @item_statuses }
    end
  end

  # GET /item_statuses/1
  # GET /item_statuses/1.xml
  def show
    @item_status = ItemStatus.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @item_status }
    end
  end

  # GET /item_statuses/new
  # GET /item_statuses/new.xml
  def new
    @item_status = ItemStatus.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @item_status }
    end
  end

  # GET /item_statuses/1/edit
  def edit
    @item_status = ItemStatus.find(params[:id])
  end

  # POST /item_statuses
  # POST /item_statuses.xml
  def create
    @item_status = ItemStatus.new(params[:item_status])

    respond_to do |format|
      if @item_status.save
        flash[:notice] = 'ItemStatus was successfully created.'
        format.html { redirect_to(@item_status) }
        format.xml  { render :xml => @item_status, :status => :created, :location => @item_status }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @item_status.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /item_statuses/1
  # PUT /item_statuses/1.xml
  def update
    @item_status = ItemStatus.find(params[:id])

    respond_to do |format|
      if @item_status.update_attributes(params[:item_status])
        flash[:notice] = 'ItemStatus was successfully updated.'
        format.html { redirect_to(@item_status) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @item_status.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /item_statuses/1
  # DELETE /item_statuses/1.xml
  def destroy
    @item_status = ItemStatus.find(params[:id])
    @item_status.destroy

    respond_to do |format|
      format.html { redirect_to(item_statuses_url) }
      format.xml  { head :ok }
    end
  end
end
