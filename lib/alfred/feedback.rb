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
		begin
			Feedback.build &block
		rescue Exception => e
			error("#{e.class.name}: #{e.message}")
			Feedback.build do
				item do
					title "Exception caught: #{e.class.name}"
					subtitle "Message: #{e.message}."
					valid false
				end
			end
		end
	end
	
	def feedback!(&block)
		puts feedback(&block).to_xml.to_s
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
			
		end
		
		def items
			@items ||= []
		end
		
		def to_xml
			document = REXML::Element.new("items")
			@items.each do |item|
				if item_element = item.to_xml
					document << item_element
				end
			end
			
			document
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
			
			def title(title)
				@title = title
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
			
			def to_hash
				uid = @uid || "#{@title} #{Feedback.start_time}"
				arg = @arg || @title
				valid = @valid.nil? ? true : @valid
				autocomplete = @autocomplete || @title
				type = @type || 'default'
				subtitle = @subtitle || ''
				icontext = (@icon and @icon.include?(:name)) ? @icon[:name] : 'icon.png'
				icontype = (@icon and @icon.include?(:type)) ? @icon[:type] : 'fileicon'
				{
					:uid => uid,
					:arg => arg,
					:valid => valid,
					:autocomplete => autocomplete,
					:type => type,
					:title => @title,
					:subtitle => subtitle,
					:icon => { 
						:text => icontext, 
						:type => icontype
					}
				}
			end
			
			def to_xml
				unless @title.nil?
					validate
					# Generate XML
					hash = to_hash
					REXML::Element.new('item').tap do |element|
						element.add_attributes 'uid' => hash[:uid], 'arg' => hash[:arg], 'valid' => hash[:valid].to_yes_no, 
							'autocomplete' => hash[:autocomplete]
						element.add_attributes 'type' => hash[:type]
						REXML::Element.new('title', element).text = hash[:title]
						REXML::Element.new('subtitle', element).text = hash[:subtitle]
						icon = REXML::Element.new("icon", element)
						icon.text = hash[:icon][:text]
						icon.add_attributes('type' => hash[:icon][:type])
					end
				end
			end
			
			private
			def validate
				(@title and not @title.empty?) or raise 'Title must be set'
			end
			
		end
		
	end

end
