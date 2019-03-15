# What is GrapeOnRails?

Nowadays, web development tends to move into Single Page App style, which is based on XHR request and communication through JSON data. Beside it, the rising of Mobile App follows up with API web service which is a MUST for our business.

Rails with nearly 8 years old is not good enough for developing APIs quickly despite the born of Rails API-only mode. Many programmers turn to [Grape](https://github.com/ruby-grape/grape) for a better DSL and more support. 
However, in order to take advantage of lots of benefits in Rails, we have to found ourselves a way to use Grape along with Rails so far.

I myself have to mount Grape routes into rails routes as well as leave rails controller and replaces by Grape API declaration. So, I decided to combine the power of two huge Framework and make your app server lightly, your code concisely and clearly.

You guys can consider this gem as an updated version for Rails API mode, I tried to mimic the Grape code in Rails without adding Grape gem. Moreover, some useful tools were included to help developing APIs easier than ever

# Why GrapeOnRails?

* Want to get rid of boilerplate code
* Want to keep using Rails api-only mode without mess with Grape
* Have an easy life

Introduce gem GrapeOnRails - which brings Grape DSL to Rails-API and help writing APIs easier than ever.

## Usage

Below is a simple example showing some of the more common features of GrapeOnRails in the context of recreating parts of the Twitter API.

#### Routes have written as a normal rails app.
```ruby
Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :statuses
    end
  end
end
```

#### GrapeOnRails makes rails controller great again.
```ruby
class Api::V1::StatusesController < ApplicationController
  before_action :authenticate!, except: :index

  def index
    Status.limit(20)
  end

  show_params do
    requires :id, type: Integer, allow_blank: false
  end
  def show
    r current_user.statuses.find(id)
  end

  create_params do
    requires :status, type: String, allow_blank: false
    optional :images, type: File
  end
  def create
    r current_user.create_status!(text: status), status: :created
  end

  update_params do
    requires :id, type: String, allow_blank: false
    requires :status, type: String, allow_blank: false
    optional :images, type: File
  end
  def update
    r current_user.statuses.find(id).update! text: status
  end

  destroy_params do
    requries :id, type: String, allow_blank: false
  end
  def destroy
    current_user.statuses.find(id).destroy!
  end
end
```
- You don't need to write any code. `authenticate!` method is there ready for you to get `current_user`.

- Params are automatically validate and able to use. Now, you guys can use `id`, `status` variable instead of `params[:id]`, `params[:status]`

- You don't need you write `params.require(:id).permit(:id, :status)` as usual, use `declared_params`, it has already filter and take valid params above.

- Instead of writting `render json: {}, ...`, special `r model, ...` method give a  help to make your code shorter.


#### Make Models suitable for API authentication
```ruby
class User < ApplicationRecord
  has_one :user_token, dependent: :destroy

  validates :...

  acts_as :user
end

class UserToken < ApplicationRecord
  belongs_to :user

  validates :...

  acts_as :user_token
end
```
Every backend APIs need a main actor like: User, Admin, ... and Token for authentication. **GrapeOnRails** give you that ability without writing any line of code.

Lets `User acts_as :user`. So, you have authentication function on `User`
```ruby
# authenticate user by email and password
User.authenticate! "user's email", "user's password"
```

Lets `UserToken acts_as :user_token`. So that, you have following core function
```ruby
# generate a new token for user
UserToken.generate! user

# find user from token
UserToken.find_token!(token).user

# renew token
user_token.renew!

# check token have expired or not
user_token.expired?

# make token expires
user_token.expires!
```

**Remember:**
- User model must contains following columns: **email, password_digest**
- UserToken model must contains following columns: **token, refresh_token, expires_at**


#### Config the gem to adapt your app
Let's create grape_on_rails.yml in folder config/ 

`$ touch config/grape_on_rails.yml`

Add following content

```yaml
access_token_header: "X-Auth-Token"
access_token_value_prefix: "Bearer"

token_configs:
  token:
    secure_length: 64
  refresh_token:
    secure_length: 64
  expires_in: <%= 30.days %>
  short_expires_in: <%= 1.days %>

error_code_key: "error_code"
error_message_key: "message"
errors:
  data_operation: 
    code: 600
    skip_create_error: true
  unauthorized:
    code: 601
    en: "Unauthorized"
    ja: "アクセスできません"
    vi: "Khong co quyen truy cap"
  record_not_found:
    code: 602
    skip_create_error: true
    en: "Record not found"
    ja: "レコードが見つかりません"
    vi: "Khong tim thay du lieu"
  record_invalid:
    code: 603
    skip_create_error: true
    en: "Record invalid"
    vi: "Du lieu khong hop le"
  validation_error:
    code: 604
    en: "Validation Error"
    ja: "バリデーションエラー"
    vi: "Xac thuc that bai"
  token_expired:
    code:  605
    en: "Expired token"
    ja: "トークンの有効期限が切れています"
    vi: "Phien lam viec het han"
  unauthenticated:
    code: 606
    en: "Unauthenticated"
    ja: "認証されていません"
    vi: "Xac thuc that bai"
  wrong_email_password:
    code: 607
    en: "Email or password is wrong"
    ja: "メールアドレスまたはパスワードが違います"
  unexpected_exception:
    code: 608
    en: "Unexpected exception"
    ja: "予期されないエクセプション"
```
- *access_token_header* and *access_token_value_prefix* is how token look like in http request header.

e.g. `X-Auth-Token: Bearer user-access-token-go-here`

- *token_configs* specifies token length, expire time, ...

Declare all errors in your API. Error response depend on it and render json response like this:
```javascript
{
  error_code: 6xx,
  message: "your error message."
}
```
For example: when you define a error in grape_on_rails.yml
```yaml
wrong_email:
  code: 606
  en: "user email is wrong"

```
Should generate APIError::WrongEmail class. From there, anywhere in rails app can easily raise exception
```ruby
raise APIError::WrongEmail
```
The error will be automatically handled by **GrapeOnRails** and response this json
```javascript
{
  error_code: 606,
  message: "user email is wrong"
}
```
Moreover, you can apply multi-language on each of errors. **GrapeOnRails** detect your locale to response right error message


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'grape_on_rails'
```

And then execute:

`$ bundle`


Or install it yourself as:

`$ gem install grape_on_rails`


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/chau-bao-long/grape-on-rails. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the GrapeOnRails project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/grape_on_rails/blob/master/CODE_OF_CONDUCT.md).
