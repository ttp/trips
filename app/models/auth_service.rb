require 'net/http'

class AuthService
  def authenticate(token)
    data = ulogin_response(token)

    if data.key?('error') || data['verified_email'] != '1'
      return false
    end

    user = User.find_by_email(data['email'])
    user = User.find_by_authentication_token(data['identity']) if user.nil?
    user = create_user(data) if user.nil?

    user
  end

  def create_user(data)
    user = User.new
    user.email = data['email']
    user.password = 'password'
    user.authentication_token = data['identity']
    user.name = data['first_name'] + ' ' + data['last_name']
    # user.skip_confirmation!
    user.save
    user
  end

  def ulogin_response(token)
    path = "/token.php?token=#{token}" \
        '&host=pohody.com.ua'

    http = Net::HTTP.new('ulogin.ru')
    res = http.get(path)

    JSON.parse(res.body)
  end
end
