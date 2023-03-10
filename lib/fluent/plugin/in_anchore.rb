#
# Copyright 2023- Josh Bressers
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require "fluent/plugin/input"

module Fluent
  module Plugin
    require "open-uri"
    require "json"

    class AnchoreInput < Fluent::Plugin::Input
      Fluent::Plugin.register_input("anchore", self)

      config_param :tag, :string, :default => "anchore"
      config_param :sbomtag, :string, :default => "anchore-sbom"
      config_param :vulntag, :string, :default => "anchore-vulns"
      config_param :url, :string, :default => nil
      config_param :username, :string, :default => nil
      config_param :password, :string, :default => nil, :secret => true
      config_param :headers, :hash, :default => nil, :secret => true

      def configure(conf)
        super
      end #configure

      def start
        super

        @terminate = false
        @thread = Thread.new(&method(:poll))
      end #start

      def shutdown
        super

        @terminate = true
        @thread.join
      end #shutdown

      def poll
        last_run = time1 = Time.now.utc.strftime('%FT%TZ')


        while true
          # some sort of loop forever
          break if @terminate

          # Make this paginate
          event_url = "%s/v1/events?since=%s&page=1&limit=100" % [@url, last_run]
          response = URI.open(event_url, :http_basic_authentication => [@username, @password]).read
          json = JSON.parse(response)
          json["results"].each { |x|
            # Write x to the output
            log.debug("Writing %s" % [x])
            router.emit(@tag, Time.now.to_i, x)


            if x["event"]["details"].key?("curr_eval")
              if x["event"]["details"]["curr_eval"].key?("analysis_status")
                if x["event"]["details"]["curr_eval"]["analysis_status"] == "analyzed"

                  digest = x["event"]["details"]["curr_eval"]["imageDigest"]
                  response = URI.open("http://enterprise-dev:8080/v1/images/%s/sboms/native" % [digest], :http_basic_authentication => ["admin", "foobar"])

                  sbom_content = ""
                  if response.content_type == "application/gzip"
                    sbom_content = Zlib::GzipReader.new(response).read
                  else
                    sbom_content = response.read
                  end
                  sbom_content = JSON.parse(sbom_content)
                  router.emit(@sbomtag, Time.now.to_i, sbom_content)

                  response = URI.open("http://enterprise-dev:8080/v1/images/%s/vuln/all" % [digest], :http_basic_authentication => ["admin", "foobar"])

                  vuln_content = ""
                  if response.content_type == "application/gzip"
                    vuln_content = Zlib::GzipReader.new(response).read
                  else
                    vuln_content = response.read
                  end
                  vuln_content = JSON.parse(vuln_content)
                  router.emit(@vulntag, Time.now.to_i, vuln_content)

                end
              end
            end

          }

          last_run = time1 = Time.now.utc.strftime('%FT%TZ')

          # Make this configurable
          sleep 10
        end
      end #poll

    end
  end
end
