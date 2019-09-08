node[:repository] = 'git@github.com:nna774/isucon8-suburi-pixiv-isucon.git'
node[:user] = 'isucon'
node[:home] = "/home/#{node[:user]}"
node[:deploy_to] = "#{node[:home]}/torb"
node[:static_dir] = "#{node[:deploy_to]}/public"
node[:app_restart] = 'echo hello'

node[:ssh_keys] = [
  # nana
  'ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAuSWaN5ZkzTLJDgliJbctzQJZhvwUPoeAjALmS2bkhymhcCFNXVU6HvsBG9LSqFgl1ghZV7Jx/oEjicaepnSC71zyr/TcIckSrp4HjNVoFqjuwUdZmC9raAvBYnoa23uvmzIQfnfWgF9fh2mGQ6pkQICvljF/nyNif2p+HN5rWSYn1s52+Bn7Sqmba1Ncxm9F/Q58l0BICRjt4QdbXSRrqGWLtPbNv+wIDdLoqrojHUcrV4Yg1J3QxdH5dpChFhE5PLRrK0Ldz9SEYg6oE7cMuew9YPv3teRLiMNwwGAUUEA8q99ur82kUs4GiGJFMOzlIwp/g+sR79TbKajhPG3Lvw==',
  'ecdsa-sha2-nistp521 AAAAE2VjZHNhLXNoYTItbmlzdHA1MjEAAAAIbmlzdHA1MjEAAACFBAEYIrOpHsdw23+Fn9aA9ISvIlrx2aUhnZqPHHM28TrxcbT8EWHG5xC3Ge6CNJ13sENPO23xa/QHs1VS2R2DQsMdOgB5oUYVMTSxmoQVXptqXcJkgLtKmWxZzvZPA2fsdfG/yvdyinwZOAx6HJVvoPM4CLXhkVWQuOHdhC61GkIeWWXyqQ==',
  'ecdsa-sha2-nistp521 AAAAE2VjZHNhLXNoYTItbmlzdHA1MjEAAAAIbmlzdHA1MjEAAACFBAAyEqw6xdtVsZVQd8CxR4LVD0zrfYW3xdfjtbnAxabztvlnfvdrVjP7zL3L39vHlmVYH4LHuoE9otnWiE6MjMvhaAG3f5kaAp3ZvC/Xs8LX+v/PU/YdAsolnS3RNcPmdv8XqsOBMeEjVdWBJYrXl/O6SX2bGvwgrQvWXuQQNrIhLfrIbA==',
  'ecdsa-sha2-nistp521 AAAAE2VjZHNhLXNoYTItbmlzdHA1MjEAAAAIbmlzdHA1MjEAAACFBABj/OA/DFLLScesRmVwzmNYPch0cRV3bqbvoVbjOg6g5JhzozAwS4dTW8cbhc1p4jdkFCJY1MBMtlDSr7Ky3uXfYwGIM18h/mggX8UyG4LCFLJmjXZGSsmgCqrIQGUysCFBOXIomtdeS/QCHProxm5iGANSOsFOuVQjwWNoK7rjik7QsQ==',

  'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCOn3xm1zTjI0H2lF9mXBZ52DvVeiWYwF38INB99jCzxet/MC0Kuf5W7zLLPR9AuzIhH3KwQwzAW+e91TKjxbhYNSoLtjywDMkWcZkLe9woCiCRh66H1ekK1RDSPp6HtU1VGPIeukqOTIsKSYK7THtAOKa/0DfaJyHl+MgO/buQiTOSO8FhDhZFuBd/PcxCCFpYUSlC1ss5V7MUybthl1fHW3AdsTWEzZ4hNdbtYGyyqhYOV1QE4xyz2SVMpqNSKog29eeSPs09G3zpKhXJIFDH6f5BOGtI6UBf4iWmy+ueH442LWtCT3dr7D/k/Sm+reVKdTMLdfQ72Er1AvDmam0j isucon',
  'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCcPHM6Vrm48ad7CzjIvkBL19tbFXsOLHfTAsVcf/0iDNApKrLdM4WTYTvFqzh5kyPRKjc1k5gLPVgsNtLz3XfaGIca8GzGqpLT905fWWfFIT8YuCi+ypZEsO+qrLfANvXgON2S58zL9YiVyxrNoZs3SHvIZT+DUdivIPAr8eDWLcVsIkqia7fG2zN2TXpInTLVrvEsn5cwpvg1RoWVsnSBnXW9kliPvFTnEQW13HzJz6yhtmhOvu1LPyva3f9Q7mvmV3OkidgtYFJd3goQ90aIiMiRk0KP06D3F8zz65OHbDVWp3X5kXga2SksUCR6W51vC3efY2z+ar1PLtqO8tJF',
].join("\n")

MItamae::RecipeContext.class_eval do
  ROLES_DIR = File.expand_path("../roles", __FILE__)
  def include_role(name)
    recipe_file = File.join(ROLES_DIR, name, "default.rb")
    include_recipe(recipe_file.to_s)
  end

  COOKBOOKS_DIR = File.expand_path("../cookbooks", __FILE__)
  def include_cookbook(name)
    names = name.split("::")
    names << "default" if names.length == 1
    names[-1] += ".rb"

    candidates = [
      File.join(COOKBOOKS_DIR, *names),
    ]
    candidates.each do |candidate|
      if File.exist?(candidate)
        include_recipe(candidate)
        return
      end
    end
    raise "Cookbook #{name} couldn't found"
  end
end
