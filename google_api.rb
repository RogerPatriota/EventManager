require 'google/apis/civicinfo_v2'

def get_info()
    civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new

    civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'

    return civic_info
end

def get_legislators(address, levels, roles)

    api_city_info = get_info()

    legislators = api_city_info.representative_info_by_address(
        address: address,
        levels: levels,
        roles: roles
    )

    return legislators
end