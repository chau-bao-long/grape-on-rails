module GrapeOnRails
  module SecuredGenerator
    def unique_random attr
      str_len = GoR.token_configs
        .public_send(attr)
        .public_send(:secure_length).to_i / 2
      loop do
        str = SecureRandom.hex str_len
        break str unless self.class.exists?(attr => str)
      end
    end
  end
end
