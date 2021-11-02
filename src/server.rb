this_dir = File.expand_path(File.dirname(__FILE__))
lib_dir = File.join(this_dir, 'lib')
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'grpc'
require 'factorial_services_pb'
require 'benchmark'

class FactorialServer < Factorial::FactorialService::Service
  def get_factorial(request, _call)
    number = 0
    time = Benchmark.realtime { number = fact(request.number) }
    puts "Cliente #{_call.peer} demorou #{time} segundos"

    Factorial::FactorialResponse.new(result: fact(request.number).to_s)
  end

  private
    def fact(n)
      return -1 if n < 0

      result = 1

      n.times { |i| result *= i + 1 }

      return result
    end
end


def main
  s = GRPC::RpcServer.new
  s.add_http2_port('0.0.0.0:50051', :this_port_is_insecure)
  s.handle(FactorialServer.new)
  # Runs the server with SIGHUP, SIGINT and SIGQUIT signal handlers to
  #   gracefully shutdown.
  # User could also choose to run server via call to run_till_terminated
  s.run_till_terminated_or_interrupted([1, 'int', 'SIGQUIT'])
end

main
