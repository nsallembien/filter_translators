require 'stringio'

def translator?(email)
    cmd = "git --no-pager shortlog --author=#{email} 2>&1"
    output = StringIO.new(`#{cmd}`)
    lines = output.readlines().select { |l| l.strip() != '' } # Filter out empty / space lines
    lines = lines.select { |l| !(l.strip() =~ /^.*\(\d+\):$/) } # Filter out author looking lines
    is_translator = true
    lines[1,lines.length].each do |line|  # First line is author name, ignore
         is_translator = false unless line =~ /l10n:/
    end
    return is_translator
end

File.readlines("contribs.csv").each do |line|
    num_commits, name, email, repo = line.split(",")
    num_commits.strip!
    email = email.strip
    email = email.gsub('<', '')
    email = email.gsub('>', '')
    name.strip!
    repo.strip!
    commits = 
    if repo.eql? "txc"
        if !translator?(email)
            puts "#{num_commits},#{name},#{email},#{repo},"
        else
            puts "#{num_commits},#{name},#{email},#{repo},translator"
        end
    else
        puts "#{num_commits},#{name},#{email},#{repo},"
    end
end
