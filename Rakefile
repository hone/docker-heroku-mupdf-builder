require 'fileutils'

S3_BUCKET_NAME = "heroku-buildpack-ruby"

desc "Generate a new mupdf shell script"
task :new, [:version, :stack] do |t, args|
  write_file = Proc.new do |version, stack|
    file = "mupdf/#{args[:stack]}/mupdf-#{args[:version]}.sh"
    puts "Writing #{file}"
    FileUtils.mkdir_p(File.dirname(file))
    File.open(file, 'w') do |file|
      file.puts <<FILE
#!/bin/bash

docker run -v `pwd`/builds:/tmp/output -e VERSION=#{args[:version]} -e STACK=#{args[:stack]} hone/mupdf-builder:#{args[:stack]}
FILE
    end
    File.chmod(0775, file)
  end

  write_file.call(args[:version], args[:stack])
end

desc "Upload a mupdf to S3"
task :upload, [:version, :stack, :staging] do |t, args|
  require 'aws-sdk'

  profile_name = "#{S3_BUCKET_NAME}#{args[:staging] ? "-staging" : ""}"
  credentials  = AWS::Core::CredentialProviders::SharedCredentialFileProvider.new(profile_name: profile_name)
  filename     = "mupdf-#{args[:version]}.tgz"
  s3_key       = "#{args[:stack]}/#{filename}"
  s3           = AWS::S3.new(credential_provider: credentials)
  bucket       = s3.buckets[profile_name]
  object       = bucket.objects[s3_key]
  output_file  = "builds/#{args[:stack]}/#{filename}"

  puts "Uploading #{output_file} to s3://#{profile_name}/#{s3_key}"
  object.write(file: output_file)
  object.acl = :public_read
end

desc "Build docker image for stack"
task :generate_image, [:stack] do |t, args|
  require 'fileutils'
  FileUtils.cp("dockerfiles/Dockerfile.#{args[:stack]}", "Dockerfile")
  system("docker build -t hone/mupdf-builder:#{args[:stack]} .")
  FileUtils.rm("Dockerfile")
end
