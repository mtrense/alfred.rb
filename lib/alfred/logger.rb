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

require 'syslog'

module Alfred
	
	def debug(message)
		log(:debug, message)
	end
	
	def info(message)
		log(:info, message)
	end
	
	def warn(message)
		log(:warning, message)
	end
	
	def error(message)
		log(:err, message)
	end
	
	def fatal(message)
		log(:critical, message)
	end
	
	private
	def log(severity, message)
		Syslog.open('Alfred-workflow', Syslog::LOG_PID) {|log| log.send severity.to_sym, message }
	end
	
end
