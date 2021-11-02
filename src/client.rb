this_dir = File.expand_path(File.dirname(__FILE__))
lib_dir = File.join(this_dir, 'lib')
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'grpc'
require 'factorial_services_pb'

def get_user_input
  print 'insira um número (0 para sair): '
  gets.chomp.to_i
end

def main
  hostname = 'localhost:50051'
  stub = Factorial::FactorialService::Stub.new(hostname, :this_channel_is_insecure)

  puts "::Calculo de fatoriais utilizando gRPC::"

  while ((number = get_user_input) != 0)
    begin
      response = stub.get_factorial(Factorial::FactorialRequest.new(number: number))
      puts "O fatorial de #{number} é #{response.result}"
    rescue GRPC::BadStatus => e
      puts "Erro: #{e.message}"
    end
  end
end

main
