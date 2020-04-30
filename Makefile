build:
	gem build ccios.gemspec

install: clean build
	gem install ccios-*.gem

clean:
	rm -f ccios-*.gem

tests:
	rake test
