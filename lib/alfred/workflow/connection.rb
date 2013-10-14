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
		
		class Connection
			
			MODIFIER_MAP = { :none => 0, :ctrl => 262144, :alt => 524288, :cmd => 1048576, :fn => 8388608, :shift => 131072 }
			
			def initialize(workflow, source, destination = nil)
				@workflow = workflow
				@source = source
				@destination = destination
			end
			
			def destination(destination)
				@destination = destination
			end
			
			# 262144 = ctrl
			# 524288 = alt
			# 1048576 = cmd
			# 8388608 = fn
			# 131072 = shift
			def modifier(modifier)
				@modifier = modifier
			end
			
			def subtext(subtext)
				@subtext = subtext
			end
			
			def generate_connection
				{}.tap do |builder|
					builder['destinationuid'] = @destination
					builder['modifiers'] = MODIFIER_MAP[@modifier || :none]
					builder['modifiersubtext'] = @subtext || ''
				end
			end
			
		end
		
	end
	
end
