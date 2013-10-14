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
	
	TYPE_MAP = {
		:keyword => 'alfred.workflow.input.keyword',
		:hotkey => 'alfred.workflow.trigger.hotkey',
		:script => 'alfred.workflow.action.script',
		:filter => 'alfred.workflow.input.scriptfilter',
		:clipboard => 'alfred.workflow.output.clipboard',
		:notification => 'alfred.workflow.output.notification',
		:large_type => 'alfred.workflow.output.largetype',
		:openurl => 'alfred.workflow.action.openurl'
	}
	
	def workflow(&block)
		wf = Workflow.new
		wf.instance_exec &block if block
		Plist::Emit.dump wf.generate_spec
	end
	
	def workflow!(&block)
		File.open('info.plist', 'w') {|file| file << workflow(&block) }
	end
	
	class Workflow
		require 'alfred/workflow/step'
		require 'alfred/workflow/connection'
		
		def id(id)
			@id = id
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
		
		def keyword(name, &block)
			step(:keyword, KeywordStep, &block)
		end
		
		def hotkey(name, &block)
			step(:hotkey, HotkeyStep, &block)
		end
		
		def script(name, &block)
			step(:script, ScriptStep, &block)
		end
		
		def filter(name, &block)
			step(:filter, FilterStep, &block)
		end
		
		def clipboard(name, &block)
			step(:clipboard, ClipboardStep, &block)
		end
		
		def notification(name, &block)
			step(:notification, NotificationStep, &block)
		end
		
		def large_type(name, &block)
			step(:large_type, LargeTypeStep, &block)
		end
		
		def openurl(name, &block)
			step(:openurl, OpenURLStep, &block)
		end
		
		def step(type, type_class, name = type, &block)
			@steps ||= {}
			step = type_class.new self, name.to_sym
			step.instance_exec &block if block
			@steps[name.to_sym] = step
		end
		
		def generate_spec
			{}.tap do |builder|
				builder['bundleid'] = @id
				builder['name'] = @name || @id[/[^.]+$/]
				builder['author'] = @author || ''
				builder['description'] = @description || ''
				builder['disabled'] = @disabled || false
				builder['readme'] = @readme || ''
				builder['url'] = @url || ''
				builder['objects'] = @steps.collect do |name, step|
					step.generate_spec
				end
				builder['connections'] = generate_connections
			end
		end
		
		def generate_connections
			{}.tap do |builder|
				@steps.collect do |name, step|
					builder[name] = step.generate_connections
				end
			end
		end
		
	end
	
end
