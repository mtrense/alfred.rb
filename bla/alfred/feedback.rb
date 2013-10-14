# encoding: UTF-8
# Copyright 2013 Max Trense
#
#	Licensed under the Apache License, Version 2.0 (the "License");
#	you may not use this file except in compliance with the License.
#	You may obtain a copy of the License at
#
#		http://www.apache.org/licenses/LICENSE-2.0
#
#	Unless required by applicable law or agreed to in writing, software
#	distributed under the License is distributed on an "AS IS" BASIS,
#	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#	See the License for the specific language governing permissions and
#	limitations under the License.

require 'rexml/document'

module Alfred
	
	def feedback(&block)
		Feedback.build &block
	end
	
	def feedback!(&block)
		Feedback.generate &block
	end
	
	class Feedback
		
		class <<self
			def start_time
				@time ||= Time.now.to_s
			end
			
			def build(&block)
				feedback = Feedback.new
				if block
					case block.arity
					when 1
						block.call feedback
					when 0
						feedback.instance_exec &block
					end
				end
				feedback
			end
			
			def generate(&block)
				puts build(&block).to_xml
			end
		end
		
		def initialize
			@items = []
		end

		def items
			@items ||= []
		end
		
		def add_item(opts = {})
			item = Item.new
			opts.each do |meth, value|
				item.send meth.to_sym, value if item.respond_to?(meth.to_sym)
			end
			@items << item
		end

		def to_xml(items = @items)
			document = REXML::Element.new("items")
			items.each do |item|
				if item_element = item.to_xml
					document << item_element
				end
			end
			
			document.to_s
		end
		
		def item(&block)
			if block
				item = Item.new
				case block.arity
				when 1
					block.call item
				when 0
					item.instance_exec &block
				end
				items << item
			end
		end
		
		class Item
			
			def initialize
				@subtitle ||= ""
				@icon ||= { :type => "default", :name => "icon.png" }
				@valid ||= true
				@type ||= "default"
			end
			
			def title(title)
				@title = title
				@uid ||= "#{@title} #{Feedback.start_time}"
				@autocomplete ||= @title
				@arg ||= @title
			end
			
			def subtitle(subtitle)
				@subtitle = subtitle
			end
			
			def icon(icon)
				@icon = icon
			end
			
			def uid(uid)
				@uid = uid
			end
			
			def arg(arg)
				@arg = arg
			end
			
			def valid(valid)
				@valid = valid
			end
			
			def autocomplete(autocomplete)
				@autocomplete = autocomplete
			end
			
			def type(type)
				@type = type
			end
			
			def to_xml
				unless @title.nil?
					element = REXML::Element.new('item')

					element.add_attributes 'uid' => @uid, 'arg' => @arg, 'valid' => @valid.to_yes_no, 'autocomplete' => @autocomplete
					element.add_attributes 'type' => 'file' if @type == "file"
					REXML::Element.new('title', element).text    = @title
					REXML::Element.new('subtitle', element).text = @subtitle
					icon = REXML::Element.new("icon", element)
					icon.text = @icon[:name]
					icon.add_attributes('type' => 'fileicon') if @icon[:type] == "fileicon"
					
					element
				end
			end
			
		end
		
	end

end
