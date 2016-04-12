require 'iiif/presentation'

namespace :archive_iiif do


  # TODO: Change this to use the CSV library to actually create the file, and to print the line to add to groups.csv
  
  module IiifParams 
    THUMBNAIL_RESOLUTION='100,100'
    SUBJECT_RESOLUTION='1500,'
    SUBJECT_OFFSET='full'
  end
  
  def service_to_full_url(service_id)
    "#{service_id}/full/full/0/default.jpg"
  end
  
  def service_to_thumb_url(service_id)
    "#{service_id}/full/100,100/0/default.jpg"
  end
  
  def process_canvas(canvas, index, archive_id)
    canvas_id = canvas['@id']
    canvas_label =  canvas.label

    # may be useful for pruning non-record frames    
    canvas_width =         canvas.width
    canvas_height =        canvas.height
    
    resource_id =          canvas.images.first['resource']['@id'] 
    resource_format =      canvas.images.first['resource']['format'] 
    service_id =           canvas.images.first['resource']['service']['@id']

    # order,file_path,thumbnail,capture_uuid,page_uri,book_uri,source_rotated,width,height,source_x,source_y,source_w,source_h
    # order,
    print "#{index},"
    # file_path,
    print "\"#{service_to_full_url(service_id)}\","
    # thumbnail,
    print "\"#{service_to_thumb_url(service_id)}\","
    # capture_uuid,
    print "\"#{archive_id}-#{index}\""
    # page_uri,
    print "\"http://digitalcollections.nypl.org/items/e38ae1d0-00b1-0133-2ced-58d385a7bbd0\","
     # book_uri,
    # width,
    # height,
    # source_x,
    # source_y,
    # source_w,
    # source_h
    print "http://digitalcollections.nypl.org/items/df712aa0-00b1-0133-fbd7-58d385a7bbd0,0,1370,1037,0,0,1370,1037"   # source_rotated,
    print "\n"
    
  end
  
  def transform_work(archive_id)
    manifest_url = "https://iiif.archivelab.org/iiif/#{archive_id}/manifest.json"
        
    connection = open(manifest_url)
    manifest_json = connection.read
    service = IIIF::Service.parse(manifest_json)
  
    print "order,file_path,thumbnail,capture_uuid,page_uri,book_uri,source_rotated,width,height,source_x,source_y,source_w,source_h\n"
  
    service.sequences.first.canvases.each_with_index do |canvas,i|
      process_canvas(canvas, i, archive_id)
    end
  
  
  end


  desc "Create subject CSV file from Internet Archive identifiers"
  task :subject_from_archive, [:archive_id] => :environment do |task, args|
    transform_work(args[:archive_id])
  end



end
