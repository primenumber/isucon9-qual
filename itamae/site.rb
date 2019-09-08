node[:repository] = 'git@github.com:nna774/isucon8-suburi-pixiv-isucon.git'
node[:user] = 'isucon'
node[:home] = "/home/#{node[:user]}"
node[:deploy_to] = "#{node[:home]}/isucari"
node[:static_dir] = "#{node[:deploy_to]}/public"
node[:app_restart] = 'systemctl  restart isucari.ruby.service'

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
