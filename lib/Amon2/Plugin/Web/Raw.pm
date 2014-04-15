package Amon2::Plugin::Web::Raw;
use strict;
use warnings;
use 5.008_005;
our $VERSION = '0.01';
use Amon2::Util ();

our $CONTENT_TYPE_MAP = {
    # text
    txt     => 'text/plain',
    xml     => 'text/xml',
    css     => 'text/css',
    csv     => 'text/csv',
    js      => 'text/javascript',

    # image
    png     => 'image/png',
    jpeg    => 'image/jpeg',
    gif     => 'image/gif',
    bmp     => 'image/bmp',

    # application
    swf     => 'application/x-shockwave-flash',
    zip     => 'application/zip',
    pdf     => 'application/pdf',
};

sub init {
    my ($class, $c) = @_;
    unless ($c->can('render_raw')) {
        Amon2::Util::add_method($c, 'render_raw', \&_render_raw);
    }
}

sub _render_raw {
    my ($c, $type, $data, $header) = @_;

    my $res = $c->create_response(200);

    my $content_type = $CONTENT_TYPE_MAP->{$type};
    die sprintf("unsupport raw type [%s]", $type) unless $content_type;

    $res->content_type($content_type);
    $res->header(%$header) if $header;
    $res->content($data);
    $res->content_length(length $data);

    return $res;
}

1;
__END__

=encoding utf-8

=head1 NAME

Amon2::Plugin::Web::Raw - render raw data

=head1 SYNOPSIS

  use Amon2::Plugin::Web::Raw;
  use Amon2::Lite;

  __PACKAGE__->load_plugins(qw/Web::Raw/);

  get '/image' => sub {
    my $c = shift;
    return $c->render_raw(png => $png_data);
  };

=head1 DESCRIPTION

Amon2::Plugin::Web::Raw generate raw data response.

=head1 METHODS $c->render_raw($type => $data, [$header]);

Generate instance of L<Plack::Response> of raw data.
support raw type see $Amon2::Plugin::Web::Raw::CONTENT_TYPE_MAP

=head1 AUTHOR

koba04 E<lt>koba0004@gmail.comE<gt>

=head1 COPYRIGHT

Copyright 2013- koba04

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut
