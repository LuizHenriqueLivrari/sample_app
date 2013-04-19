# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe User do

	before { @user = User.new(name: "Example User", email: "user@example.com", password: "testes", password_confirmation: "testes") }

	subject { @user }

	it { should respond_to( :name ) }
	it { should respond_to( :email ) }
	it { should respond_to( :password_digest ) }
	it { should respond_to( :password ) }
	it { should respond_to( :password_confirmation ) }
	it { should respond_to( :remember_token ) }
	it { should respond_to( :admin ) }
	it { should respond_to( :authenticate ) }

	it { should be_valid }
	it { should_not be_admin }

	describe "with admin attribute set to 'true'" do
		before do
			@user.save!
			@user.toggle!(:admin)
		end

		it { should be_admin }
	end

	describe "when name is not present "do
		before { @user.name = ""}
		it { should_not be_valid }
	end

	describe "when e-mail is not present "do
		before { @user.email = ""}
		it { should_not be_valid }
	end

	describe "when password is not present "do
		before { @user.password = @user.password_confirmation = ""}
		it { should_not be_valid }
	end

	describe "when name is too long "do
		before { @user.name = 'a' * 51 }
		it { should_not be_valid }
	end

	describe "when email format is invalid"do
		it "should be invalid"do
			addresses = %w[user@foo,com user_at_foo.org example.user@foo.
			foo@bar_baz.com foo@bar+baz.com]
			addresses.each do |invalid_address|
				@user.email = invalid_address
				@user.should_not be_valid
			end
		end
	end

	describe "when email format is valid"do
		it "should be valid"do
			addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
			addresses.each do |valid_address|
				@user.email = valid_address
				@user.should be_valid
			end
		end
	end

	describe "when lowercase email address is already taken" do
		before do
			user_with_same_email = @user.dup
			user_with_same_email.save
		end

		it { should_not be_valid }
	end

	describe "when UPPERCASE email address is already taken" do
		before do
			user_with_same_email = @user.dup
			user_with_same_email.email.upcase!
			user_with_same_email.save
		end

		it { should_not be_valid }
	end

	describe "quando as senhas sao diferentes..." do
		before { @user.password_confirmation = "diferente" }
		it { should_not be_valid }
	end

	describe " com uma senha muito curta... " do
		before { @user.password = @user.password_confirmation = 'a' * 5 }
		it { should be_invalid }
	end

	describe " com o valor de retorno da autenticacao... " do

		before { @user.save }
		let( :usuario_valido ) { User.where( email: @user.email ).first }

		describe " com uma senha valida... " do
			it { should == usuario_valido.authenticate( @user.password ) }
		end

		describe " com uma senha invalida... " do
			let( :usuario_invalido ) { usuario_valido.authenticate( 'senha incorreta' ) }

			it { should_not == usuario_invalido }
			specify { usuario_invalido.should be_false }
		end

	end

	describe " email com letras maiusculas e minusculas... " do
		let( :email_misturado ) { 'AbCdDeF@gHiJkL.cOm' }

		it " tem que salvar tudo como letra minuscula... " do
			@user.email = email_misturado
			@user.save
			@user.reload.email.should == email_misturado.downcase
		end
	end

	describe "remember token" do
		before { @user.save }
		its(:remember_token) { should_not be_blank }
	end

end