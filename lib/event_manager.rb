require 'csv'
require './google_api'
require 'erb'

def read_file(key)
    begin
        content = CSV.open(  # Read the content of the CSV as array of each line, making the heard (first line) from Str to Symbol
            'event_attendees.csv',
            headers: true,
            header_converters: :symbol
            )
    rescue StandardError => e
        puts "An erro occurred while reading this file: #{e}"
    end
end

def validate_code(zipcode)
    #p "#{zipcode} -> #{zipcode.to_s.rjust(5, '0')[0..4]}"
    return zipcode.to_s.rjust(5, '0')[0..4]
end

def validate_phone(phone)
    #If the phone number is less than 10 digits, assume that it is a bad number [0]
    #If the phone number is 11 digits and the first number is not 1, then it is a bad number [0]
    #If the phone number is more than 11 digits, assume that it is a bad number [0]

    #If the phone number is 10 digits, assume that it is good [0]
    #If the phone number is 11 digits and the first number is 1, trim the 1 and use the remaining 10 digits [0]

    phone = phone.gsub(/[-(). +]/, '').to_s

    if phone.length == 10
        return phone
    end
    if phone.length == 11 and phone.start_with? '1'
        phone[0] = ''
        return phone
    else
        return 'bad number'
    end
    
end

def get_legislators_zipcode(zipcode)

    begin
        legislator_info = get_legislators(zipcode, 'country', ['legislatorUpperBody', 'legislatorLowerBody'])
        legislators = legislator_info.officials

        #legislators_name = legislators.map(&:name).join(", ")
      rescue StandardError => e
          puts "An error happen during the process -> #{e}"
      end
    
    return legislators

end

def get_values(file, key)
    file_content = read_file(file)
    key_in_symbol = key.to_sym.downcase

    template_letter = File.read('template_form.erb')
    erb_template = ERB.new template_letter

    file_content.each do | line |
        zipcode = validate_code(line[key_in_symbol])
        name = line[:first_name]
        phone = validate_phone(line[:homephone])

        puts "#{line[:homephone]} -> #{phone}"

        #legislators = get_legislators_zipcode(zipcode)

        #form_letter = erb_template.result(binding)

        #if legislators_name != nil
            #person_letter = template_letter.gsub('FIRST_NAME', name)
            #person_letter.gsub!('LEGISLATORS', legislators_name)
       # end

    end
end

get_values('event_attendees.csv', 'Zipcode')


#read_attend("first_Name")
