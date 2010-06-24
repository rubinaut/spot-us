class Channel < ActiveRecord::Base
  validates_presence_of   :title, :channel_image_file_name, :description
  validates_uniqueness_of :title
  has_attached_file :channel_image, APP_CONFIG[:paperclip].merge(
                    :styles => { :thumb => '44x44#', :medium => "200x150#" },
                    :default_url => "/images/default_avatar.png",
                    :path        => "#{APP_CONFIG[:paperclip][:path_prefix]}" <<
                                    "channels/:attachment/:id_partition/:basename_:style.:extension",
                    :url         => "#{APP_CONFIG[:paperclip][:url_prefix]}" <<
                                    "channels/:attachment/:id_partition/:basename_:style.:extension"
                  ).except(:path_prefix, :url_prefix)
  
  named_scope :hilited, :conditions => "channels.status = 'hilited'"
  #named_scope :by_network, lambda {|network|
  #  return {:conditions => "channels.status = 'hilited'"} unless network
  #  { :conditions => 
  #    ["id in (select channel_id from channel_pitches where pitch_id in (select id from news_items where network_id = ? ))", 
  #                  network.id] }
  #}
  
  has_many :pitches, :through => :channel_pitches, :order => "created_at desc"
  has_many :channel_pitches
  has_and_belongs_to_many  :networks
  
  def self.by_network(network)
    return network ? network.channels : find(:all, :conditions => "channels.status = 'hilited'") 
  end
  
  def hilite_channel
    self.status = "hilited"
  end
  
  def to_s
    title
  end
  
  def to_param
    "#{id}-#{to_s.parameterize}"
  end
  
end
