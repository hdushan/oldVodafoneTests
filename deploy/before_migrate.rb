Chef::Log.info("Precompiling assets...")
execute "rake assetpack:build" do
  cwd release_path
  command "bundle exec rake assetpack:build"
end
