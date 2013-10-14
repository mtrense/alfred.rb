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

require 'thor'

module Alfred
	
	class Generator < Thor
		include Thor::Actions
		
		source_root File.expand_path('../../', __FILE__)
		
		desc 'new NAME', 'Create a new Alfred workflow'
		def new(name)
			@name = name
			empty_directory name
			empty_directory "#{name}/alfred"
			%W{ alfred.rb alfred/feedback.rb alfred/logger.rb alfred/util.rb alfred/settings.rb }.each do |file|
				copy_file "#{file}", "#{name}/#{file}"
			end
			template 'alfred/generator/sample_script_filter.rb.erb', "#{name}/sample_script_filter.rb"
			template 'alfred/generator/workflow_spec.rb.erb', "#{name}/workflow_spec.rb"
		end
		
		desc 'spec', 'Generates Alfreds workflow spec'
		def spec
			
		end
		
		desc 'update', 'Updates local libs from gem'
		def update
			
		end
		
		desc 'bundle', 'Bundles this workflow so it can be imported in Alfred'
		def bundle
			
		end
		
	end
	
end
