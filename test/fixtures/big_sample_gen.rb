#!/usr/bin/env ruby

require 'securerandom'


def write_node(file, id, tabs = 0)
  t = "\t" * tabs
  file.write("#{t}<node geo_id = \"#{id}\">\n")
end

def write_node_name(file, tabs = 0)
  name = SecureRandom.random_number(36**40).to_s(36)
  t = "\t" * tabs
  file.write("#{t}<node_name>#{name}</node_name>\n")
end

def close_node(file, tabs = 0)
  t = "\t" * tabs
  file.write("#{t}</node>\n")
end

begin
  file = File.open("big_data.xml", "w")
  file.write <<EOF
<?xml version="1.0" encoding="utf-8"?>
<taxonomies>
<taxonomy>
<taxonomy_name>World</taxonomy_name>
EOF

  # 10 root nodes
  (1..10).each do |a|
    write_node(file,a)
    write_node_name(file, 1)

    # 50 level 1
    (1..50).each do |b|
      b += (100 * a)  # id offset
      write_node(file,b,1)
      write_node_name(file,2)
      # 60 level 2
      (1..60).each do |c|
        c += (100 * b) # id offset
        write_node(file,c,2)
        write_node_name(file,3)
        (1..10).each do |d|
          d += (100 * c)
          write_node(file,d,3)
          write_node_name(file,4)
          close_node(file,3)
        end
        close_node(file,2)
      end
      close_node(file,1)
    end
    close_node(file)
  end


  file.write <<EOF
</taxonomy>
</taxonomies>
EOF
rescue IOError => e
  #some error occur, dir not writable etc.
ensure
  file.close unless file == nil
end
