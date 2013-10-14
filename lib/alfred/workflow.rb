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

require 'plist'

module Alfred
	
	def workflow(&block)
		wf = Workflow.new
		wf.instance_exec &block if block
		wf.generate_spec
	end
	
	def workflow!(&block)
		File.open('info.plist', 'attr_writer :attr_names') {|file| file << workflow(&block) }
	end
	
	class Workflow
		require 'alfred/workflow/step'
		require 'alfred/workflow/connection'
		
		def initialize
			@author = ''
			@description = ''
			@disabled = false
			@readme = ''
			@url = ''
		end
		
		def id(id)
			@id = id
			@name = id[/[^.]+$/] unless @name
		end
		
		def name(name)
			@name = name
		end
		
		def author(author)
			@author = author
		end
		
		def description(description)
			@description = description
		end
		
		def disabled(disabled)
			@disabled = disabled
		end
		
		def readme(readme)
			@readme = readme
		end
		
		def url(url)
			@url = url
		end
		
		def step(name, &block)
			@steps ||= {}
			step = Step.new self, name.to_sym
			step.instance_exec &block if block
			@steps[name.to_sym] = step
		end
		
		def generate_spec
			builder = {}
			builder['bundleid'] = @id
			builder['name'] = @name
			builder['author'] = @author
			builder['description'] = @description
			builder['disabled'] = @disabled
			builder['readme'] = @readme
			builder['url'] = @url
			# TODO: generate objects and connections
			Plist::Emit.dump builder
		end
		
		def generate_objects
			
		end
		
		def generate_connections
			
		end
		
	end
	
end
