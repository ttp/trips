module Features
  module SessionHelpers
    def sign_in(user)
      visit new_user_session_path
      fill_in 'Email', with: user.email
      fill_in I18n.t('user.password'), with: user.password
      click_button I18n.t('helpers.links.sign_in')
    end
  end
end
