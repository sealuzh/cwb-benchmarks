require 'forwardable'
module WordpressBench
  # Add batch funtionality to FakterPress
  # @see FakerPress
  class BatchedFakerPress
    extend Forwardable
    def_delegators :@faker, :index, :login, :save_api_key, :delete_all_fake_data

    def initialize(url, batch_size)
      @faker = FakerPress.new(url)
      @batch_size = batch_size
    end

    def generate_users(min, opts = {})
      run_in_batches(:generate_users, min, opts)
    end

    def generate_posts(min, opts = {})
      run_in_batches(:generate_posts, min, opts)
    end

    def generate_comments(min, opts = {})
      run_in_batches(:generate_comments, min, opts)
    end

    def generate_terms(min, opts = {})
      run_in_batches(:generate_terms, min, opts)
    end

    private

      def run_in_batches(method, min, opts = {})
        num = (opts.key?(:max) ? rand(min..opts[:max]) : min)
        full_batches = (num / @batch_size).floor
        full_batches.times do
          @faker.send(method, @batch_size, opts)
        end
        remaining = num - (full_batches * @batch_size)
        @faker.send(method, remaining, opts)
      end
  end
end
