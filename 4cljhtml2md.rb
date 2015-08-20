require 'nokogiri'
require 'reverse_markdown'

page = Nokogiri::HTML(ARGF.read)

id = page.css("#prob-number").text
title = page.css("#prob-title").text

difficulty = page.css("#tags tr:nth(1) td:nth(2)").text
topics = page.css("#tags tr:nth(2) td:nth(2)").text.split(/\s+/).map {|t| "##{t}"}.join(" ")

desc = page.css("#prob-desc")
test_cases_table = desc.css("table").remove
test_cases = test_cases_table.css('tr').each_with_object([]){|tr, o| o << tr.css('td:nth(2)').text}
desc_md = ReverseMarkdown.convert desc.to_s, github_flavored: true

$stdout.puts DATA.read % {
  title: title,
  difficulty: difficulty,
  tags: topics,
  description: desc_md.strip.gsub(/\r/, ''),
  test_cases: test_cases.map { |t| "```clojure\n#{t}\n```" }.join("\n")
}

__END__
# %{title}

###### %{difficulty}
###### %{tags}

%{description}

# Test Cases
%{test_cases}

# Solution
```clojure
__
```
