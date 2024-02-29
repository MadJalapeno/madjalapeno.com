module Jekyll
    require 'csv'
    require 'jekyll'
    class CSVToTable < Liquid::Tag

        def initialize(tagName, content, tokens)
            super
            @content = content
          end
      
          def render(context)

            # stylin'
            thClass = %{border-b bg-slate-600 dark:border-slate-600 font-medium p-4 text-slate-400 dark:text-slate-200 text-left}
            trClass = %{border-b border-slate-100 dark:border-slate-700 p-2 text-slate-500 dark:text-slate-400}
            
            # get the filename and path together
            dataname = "#{context[@content.strip]}"
            dataname = dataname, ".csv"
            datapath = File.join Dir.pwd, "_data/csv/"
            datafile = datapath, dataname
            datafile = datafile.join         

            if File.file?(datafile) # check file exists
                # Console Output for Debugging 
                debug = "🧲       csv2table: ", datafile
                debug = debug.join
                puts debug

                output = []

                csv_data = CSV.read(datafile, :headers => true)

                data = Hash.new         
                data['keys'] = csv_data.headers
                data['content'] = csv_data.to_a[1..-1]
                
                # head
                output = "<tr>\n"
                for key in data['keys']
                    key = "  <th class=\"#{thClass}\">#{key}</th>\n"
                    output = output, key
                end
                output = output, "</tr>\n\n"

                # content
                for key in data['content']
                    output = output, "<tr>\n"
                        for k in key
                        k = "  <td class=\"#{trClass}\">#{k}</td>\n"
                        output = output, k
                        end
                output = output, "</tr>\n\n"    
                end

            else
                output = "File Not Found."
            end

            output
        end
        Liquid::Template.register_tag "csv2table", self
    end
  end
