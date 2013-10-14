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

module Alfred
	
	class Workflow
		
		class Step
			
			def initialize(workflow, type, name = type)
				@workflow = workflow
				@type = type
				@name = name
			end
			
			def ypos(ypos)
				@ypos = ypos
			end
			
			def connect(target = nil, &block)
				@connections ||= []
				connection = Connection.new @workflow, self, target
				connection.instance_exec &block if block
				@connections << connection
			end
			
			def generate_spec
				{}.tap do |builder|
					builder['config'] = generate_config
					builder['type'] = Alfred::TYPE_MAP[@type]
					builder['uid'] = @name || ''
					builder['version'] = @version || 0
				end
			end
			
			def generate_connections
				[*@connections].collect do |connection|
					connection.generate_connection
				end
			end
			
		end
		
		class FilterStep < Step
			
			ARGUMENT_MAP = { :required => 0, :optional => 1, :no_argument => 2 }
			ESCAPE_MAP = { 
				:spaces => 1, 
				:backquotes => 2, 
				:double_quotes => 4, 
				:brackets => 8, 
				:semicolons => 16, 
				:dollars => 32, 
				:backslashes => 64,
				:all => 127
			}
			SCRIPT_TYPE_MAP = { :bash => 0, :php => 1, :ruby => 2, :python => 3, :zsh => 5 }
			
			# 0 = required
			# 1 = optional
			# 2 = no arg
			def argument(argument)
				@argument = argument
			end
			
			def title(title)
				@title = title
			end
			
			def running_placeholder(running_placeholder)
				@running_placeholder = running_placeholder
			end
			
			def keyword(keyword)
				@keyword = keyword
			end
			
			# or'ed
			# 1 = spaces
			# 2 = backquotes
			# 4 = dquotes
			# 8 = brackets
			# 16 = semicolons
			# 32 = dollars
			# 64 = backslashes
			def escaping(*escaping)
				@escaping = escaping
			end
			
			# 0 = bash
			# 1 = php
			# 2 = ruby
			# 3 = python
			# 5 = zsh
			def script_type(script_type)
				@script_type = script_type
			end
			
			def space(space)
				@space = space
			end
			
			def script(script)
				@script = script
			end
			
			def generate_config
				{}.tap do |builder|
					builder['argumenttype'] = ARGUMENT_MAP[@argument || :no_argument] # No argument is default
					builder['text'] = @text || ''
					builder['title'] = @title || ''
					builder['keyword'] = @keyword || ''
					builder['runningsubtext'] = @running_placeholder || ''
					builder['withspace'] = @space || false
					builder['escaping'] = (@escaping || [:all]).inject(0) {|r, e| r = r|ESCAPE_MAP[e] ; r }
					builder['type'] = SCRIPT_TYPE_MAP[@script_type || :bash]
					builder['script'] = @script || ''
				end
			end
			
		end
		
		class NotificationStep < Step
			
			def text(text)
				@text = text
			end
			
			def title(title)
				@title = title
			end
			
			def only_show_on_query(only_show_on_query)
				@only_show_on_query = only_show_on_query
			end
			
			def sticky(sticky)
				@sticky = sticky
			end
			
			def generate_config
				{}.tap do |builder|
					builder['text'] = @text || ''
					builder['title'] = @title || ''
					builder['onlyshowifquerypopulated'] = @only_show_on_query || false
					builder['sticky'] = @sticky || false
				end
			end
			
		end
		
		class OpenURLStep < Step
			
			def url(url)
				@url = url
			end
			
			def utf8(utf8)
				@utf8 = utf8
			end
			
			def plusspaces(plusspaces)
				@plusspaces = plusspaces
			end
			
			def generate_config
				{}.tap do |builder|
					builder['url'] = @url || ''
					builder['utf8'] = @utf8 || true
					builder['plusspaces'] = @plusspaces || false
				end
			end
			
		end
		
	end
	
end
