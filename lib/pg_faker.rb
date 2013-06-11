require 'pg_faker/version'

module PG
  class Connection
    class << self
      attr_accessor :fake_delays, :fake_errors, :fake_strategy, :fake_delay_seconds

      def start_intermittent_delay_and_error
        @fake_strategy = lambda {|m, *args| PG::Connection.fake_delays = [true, false].sample; PG::Connection.fake_errors = [true, false].sample; puts "#{m}(#{args.inspect}) fake_delays=#{PG::Connection.fake_delays} fake_errors=#{PG::Connection.fake_errors}" }
      end
      
      def stop_intermittent_delay_and_error
        @fake_strategy = nil
      end

      def alter_methods(*ms)
        PG::Connection.class_eval do
          ((ms if ms.size > 0) || instance_methods(false)).each do |m|
            alias_method "orig_#{m}".to_sym, m
            eval <<-eos            
              def #{m}(*args)
                PG::Connection.fake_strategy.call(#{m.to_sym.inspect}, *args) if PG::Connection.fake_strategy.is_a?(Proc)
                sleep(PG::Connection.fake_delay_seconds) if PG::Connection.fake_delays
                puts "intercepted: PG::Connection.#{m} \#{args.inspect}"
                raise PG::Error.new("fake error raised by pg_faker") if PG::Connection.fake_errors
                orig_#{m} *args          
              end
            eos
          end
        end
      end
      alias_method :alter_method, :alter_methods

      def unalter_methods(*ms)
        PG::Connection.class_eval do
          meths = instance_methods(false)
          ((ms if ms.size > 0) || meths).each do |m|
            orig_m = "orig_#{m}".to_sym
            alias_method m, orig_m if meths.include?(orig_m)
            remove_method orig_m
          end
        end
      end
      alias_method :unalter_method, :unalter_methods
    end
  end
end

PG::Connection.fake_delay_seconds = 5
