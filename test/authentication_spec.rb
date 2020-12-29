require 'rspec'
require_relative '../lib/loads'

def given_password(account, password)
  allow(@profile).to receive(:password).with(account).and_return(password)
end

def given_otp(otp)
  allow(@token).to receive(:random_token).and_return(otp)
end

def should_be_valid(account, password)
  is_valid = @authentication.valid?(account, password)
  expect(is_valid).to be(true)
end

def should_be_invalid(account, password)
  is_valid = @authentication.valid?(account, password)
  expect(is_valid).to be(false)
end

describe 'Authentication' do
  before do
    @profile = double
    @token = double
    @authentication = AuthenticationService.new(@profile, @token)
  end

  after do
    # Do nothing
  end
  describe ":is_valid" do
    context "when valid" do
      it 'should be return true' do
        account = 'joey'
        password = '91'
        otp = '0' * 6
        given_password(account, password)
        given_otp(otp)
        should_be_valid(account, password + otp)
      end
    end
    context "when invalid" do
      it 'should be return false' do
        account = 'joey'
        given_password(account, '91')
        given_otp('0' * 6)
        should_be_invalid(account, 'wrong password')
      end
    end
  end

end

