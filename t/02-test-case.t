
use v6;

use Test;

my $NUM_COMMANDS = 5;

plan 6 + $NUM_COMMANDS;

my $code = qq{<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head profile="http://selenium-ide.openqa.org/profiles/test-case">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link rel="selenium.base" href="http://some-server:3000/" />
<title>Login</title>
</head>
<body>
<table cellpadding="1" cellspacing="1" border="1">
<thead>
<tr><td rowspan="1" colspan="3">Login</td></tr>
</thead><tbody>
<tr>
	<td>open</td>
	<td>/login</td>
	<td></td>
</tr>
<tr>
	<td>type</td>
	<td>name=username</td>
	<td>admin</td>
</tr>
<tr>
	<td>type</td>
	<td>name=password</td>
	<td>123</td>
</tr>
<tr>
	<td>clickAndWait</td>
	<td>//button[@type='submit']</td>
	<td></td>
</tr>
<tr>
	<td>verifyTitle</td>
	<td>regex:Home</td>
	<td></td>
</tr>

</tbody></table>
</body>
</html>
};

use Parse::Selenese;

my $parser = Parse::Selenese.new;
my $result = $parser.parse($code);
ok($result.defined, "Code parsed successfully");
my $test_case = $result.ast;
ok($test_case.defined, "Well defined");
ok($test_case ~~ Parse::Selenese::TestCase);
ok($test_case.name eq 'Login', 'Correct title');
ok($test_case.base_url eq 'http://some-server:3000/', 'Correct base url');
ok($test_case.commands.elems == $NUM_COMMANDS, "Found $NUM_COMMANDS commands");
for 0..$NUM_COMMANDS-1 {
  ok($test_case.commands[$_] ~~ Parse::Selenese::Command, "index #$_ is a command");
}

