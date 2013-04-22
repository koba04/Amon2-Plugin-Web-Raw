# NAME

Amon2::Plugin::Web::Raw - render Raw Data

# SYNOPSIS

    use Amon2::Plugin::Web::Raw;
    use Amon2::Lite;

    __PACKAGE__->load_plugins(qw/Web::Raw/);

    get '/image' => sub {
      my $c = shift;
      return $c->render_raw(png => $png_data);
    };

# DESCRIPTION

Amon2::Plugin::Web::Raw generate raw data response.

# METHODS $c->render\_raw($type => $data);

Generate instance of [Plack::Response](http://search.cpan.org/perldoc?Plack::Response) of Raw data.
support raw type is png, jpeg and gif.

# AUTHOR

koba04 <koba0004@gmail.com>

# COPYRIGHT

Copyright 2013- koba04

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# SEE ALSO
