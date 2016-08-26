require "yequel/version"

module Yequel

require 'yaml/store'

require 'hash_dot'  
require 'will_paginate/array'

class Model
  attr_accessor :name, :rarray     #, :rkeys
  
  Hash.use_dot_syntax = true

  # Initialize the model object. Provides a wrapper around the dataset
  # Each table is created as unique class, and an instance is created
  #
  # Example:
  #   class Artists < Yequel::Model
  #   end
  #   Artist=Artists.new
  #  
  def initialize(name)
    @name = name
    load       
  end
  
  # Loads the dataset with the name provided from initialization
  # Method is also used to refresh data after a dataset action
  # YAML::Store data will be loaded into a hash image (:dshash) that
  # is accessible using the :id number as a key
  # Hash will be converted to a Array of hashed records to support
  # querying of the dataset
  #
  # Example:
  #   load
  def load
    #p 'loading ...'
    #p @name
    @rarray = Array.new
    begin
      dshash = YAML.load_file('db/'+@name+'.store') 
      #p dshash
      #@rkeys = Array.new
      #p 'loading ...'
      dshash.each {|k,v|           # converts strings into symbols
        cid = dshash[k]["id"]
        next if cid < 1            # do not transform if id < 1 
        #@rkeys << k
        rhash = Hash.new     
        v.each {|k2,v2|
        #p k2
        #p v2
          rhash[k2.to_sym] = v2
        }
        @rarray << rhash
      }
    rescue
      p 'no file now'  
      self.insert({:id=>0})
    end
  end
  
  def store
    dshash = Hash.new
    @rarray.each { |item|
      outhash = Hash.new
      item.each { |k,v| outhash[k.to_s] = v}
      dshash[item[:id]]=outhash
    }
    File.open('db/'+@name+'.store', 'w') do |out|   # To file
      YAML.dump(dshash, out)
    end    
  end

  # Insert is an action command and adds new records to the dataset
  # All data is stored in string format
  # An argument error is thrown if the record key is already used
  #
  # Examples:
  #   Artist.insert(:id=>1, :name=>"YJ")  
  def insert (args)
    #p @name
    #p '.......'
    p args
    p self.rarray
    if self.rarray.get(args[:id]).nil?
      model={:mod_name=>@name}
      p self
      #self.rarray << args.merge(model)
      self.rarray << args  
      self.store
    else
      raise ArgumentError, 'Cannot insert - id already exists', caller
    end
  end
  
  # Update is an action command and updates existing records
  # An argument error is thrown if the record key does not exist
  #
  # Examples:
  #   Artist.update(:id=>1, :name=>"YJM")   
  def update (args)
    p 'updating ...'
    if self.rarray.get(args[:id])    
      key = args[:id] - 1
      @rarray[key].merge!(args)
    else
      raise ArgumentError, 'Cannot update - id not found', caller
    end
    self.store
  end
  
  # Delete is an action command that deletes a single record
  # An argument error is thrown if the record key does not exist
  #
  # Examples:
  #   Artist.delete(4)  
  def delete(key)
    result = @rarray.get(key)
    if result
      @rarray.delete(result)
      store
    else
      raise ArgumentError,'Cannot delete - no matching id', caller  
    end
  end

  # First is query command that shows the first record in the dataset
  #
  # Examples:
  #   Artist.first
  #   Artist.first(:name=>'AS')   
  
  def first(options ={})
    if options.length > 0
      @rarray.where(options).first.merge!({:mod_name=>self.name})
    else
      @rarray.first.merge!({:mod_name=>self.name})
    end
  end

  # Last is query command that shows the last record in the dataset
  #
  # Examples:
  #   Artist.last  
  def last
    @rarray.reverse.first    
  end    

  # All is query command that shows all records in the dataset
  #
  # Examples:
  #   Artist.all    
  def all
    @rarray
  end

  # Count is query command that counts the records in the dataset
  #
  # Examples:
  #   Artist.count   
  def count
    @rarray.length
  end
  
  # [] is query command that shows a record base on the :id key
  #
  # Examples:
  #   Artist[1]    
  def[](key)
    #k = @rkeys.index(key)
    #@rarray[k]
    p key
    #p self.rarray
    self.rarray.get(key).merge!({:mod_name=>self.name})
  end
  
  # Order is a query command that orders an array based on a key
  # This command is chainable 
  def order(key)
    #newarray=Array.new
    #@dataset.values.each { |item| newarray << item.varray}
    #newarray.order(key)  
    @rarray.order(key)
  end
  
  # Where is a query command that filters the array
  # This command is chainable
  def where(*args)
    @rarray.where(*args)
  end
  
  #end

  #class Array < Array
  #end
  
  class Hash < Hash
    Hash.use_dot_syntax = true
    include ObjectSpace
    
    def save
      p self
      p self[:mod_name]
      p 'saving ...'
      object = nil
      ObjectSpace.each_object(Model) {|obj| object=obj if object.nil? and obj.name==self[:mod_name]}
      p object
      p object.name
      p '++++++++'
      object.update(self)
    end 
  end

  class Array < Array
  
    def method_missing(method, *args)
      p 'refactoring'
      puts "Method: #{method} Args: (#{args.join(', ')})"
      p self
    end
  
    def get(key)
      #self.each { |item| p item}
      #p 'getting'
      #p key
      #p self
      result = Array.new
      #self.each { |item| p item[:id]}
      self.each { |item| result<<item if key.to_i==item[:id]}
      result[0]
    end
    
    # Order is a query command that orders an array based on a key
    # This command is chainable 
    def order(key)
      newkeys=Hash.new
      self.each { |item| newkeys[item[key].to_s+"|"+item[:id].to_s]=item[:id]}
      #newkeys=newkeys.sort
      #p newkeys.sort
      newarray=Array.new
      #newkeys.sort.each { |ary| p ary}
      newkeys.sort.each { |ary| newarray << self.get(ary[1])} 
      newarray   
    end
  
    # Where is a query command that filters the array
    # This command is chainable
    # There are many variations in the selection criteria
    #
    # Examples:
    #   Artist.where(:name => 'AS')
    #   Artist.where('id > 0')
    #   Artist.where('id <= 2')
    #   Artist.where('id >= 2')
    #   Artist.where('id != 1')
    #   Artist.where('id = ?', 1)
    #   Artist.where(:id => 2).where(:name => 'AS')    
    def where(*args)
      #p 'in where'
      #p args.length
  
      flatargs = args[0] 
      if flatargs.class != String     # operations are identities
      #p 'hshing ....'
        hsh = flatargs
        #p hsh
        key = hsh.keys[0]             # required key
        val = hsh.values[0]           # required value
        atype = 1
        atype = 4 if val.class == Array       
      else
        if flatargs.index(" ")
        #p 'splitting ...'
          atype = 2
          phrase = flatargs.split(' ')
          key  = phrase[0].to_sym
          oper = phrase[1]
          val  = phrase[2]
          atype = 3 if oper == '!=' 
          if args.length == 2
            val = args[1]
            atype = 1
          end
          val = val.to_i # if val.match(/\A[+-]?\d+?(\.\d+)?\Z/)        
        end
      end
  
      #p ':::::::::::::::::'
      #p flatargs
      #p phrase
      #p key
      #p oper
      #p val
  
      selected = Array.new    # now run the query
      
      # original = self.dsarray          # this is different
      original = self
      
      original.each { |item|
        item.each {|k, v|
        #p 'querying ...'
          #item[:super_name] = self.name
          selected << item if atype == 1 and key == k and val == v
          selected << item if atype == 3 and key == k and val != v
          if atype == 2 and key == k  # handle quoted expression
            if oper == '>' and v > val
              selected << item
            end
            if oper == '<' and v < val
              selected << item
            end 
            if oper == '<=' and v <= val
              selected << item
            end  
            if oper == '>=' and v >= val
              selected << item
            end       
          end
        }
      }
      
      #p selected
      #p selected.class
      #p '+++++++++++++++++++++'
      selected
       
    end  
    
    def reverse
      if self.length > 0
        result = Array.new
        i = self.length-1
        while i > -1
          result << self[i]
          i = i - 1
        end        
        result
      else
        self
      end
    end
    
    # Page is a query command that is used to support will_paginate
    # This command is used at the end of query chain
    #
    # Examples:
    #   Artist.where('id > 0').page(1, 15)  
    def page(page, per_page=10)
      page = (page || 1).to_i
      self.paginate(:page => page, :per_page => per_page)   
    end
   
    # select_map is a method that extracts the values from the array
    # The result is an array for the argument (i.e., hash key)
    # Result is returned in the order of the source array
    #
    # Examples:
    #   Artist.where('id > 0').select_map(:name)
    def select_map(arg)
      mapped = Array.new
      if self.length > 0  
        self.each{ |k|            # the each object changes
          if k[arg]
            mapped << k[arg]
          else
            mapped = []           # key is not valid
          end
        }
      end
      mapped    
    end  
    
  end # end of Array

end # end of Model

#-----------------------------------------------------------------------
end # end of module


#Artist = Model.new
#Artist = Yequel::Model.new('artists')

#p Artist
#Artist.insert(:id=>1, :name=>"YJ", :level=>1)
#p Artist.count
#Artist.insert(:id=>2, :name=>"AS", :level=>1)
#p Artist.count
#Artist.insert(:id=>3, :name=>"AS", :level=>3)
#p Artist
#p Artist.count
#p Artist.all
#p Artist.first
#p Artist.last
#p Artist[2]
#p Artist[2][:name]='xxx'
#p Artist[2]
#Artist.update(:id=>2, :name=>"XXXXX")
#p Artist
#p Artist.order(:name)
#Artist.where(:id=>1)
