use strict;
use Test::More;
use Test::Exception;

{
    package MyApp;
    use parent qw/ Amon2 /;
}

{
    package MyApp::Web;
    use parent -norequire, qw/ MyApp /;
    use parent qw/ Amon2::Web /;

    __PACKAGE__->load_plugins(
        'Web::Raw',
    );
}

my $c = MyApp::Web->new(request => Amon2::Web::Request->new({}));

subtest 'render_raw' => sub {
    # load sample png
    open my $fh, 't/sample.png' or die "Can't open file t/sample.png : $!";
    my $data = do { local $/; <$fh> };
    close $fh;

    my $res = $c->render_raw(png => $data);
    is $res->status, 200, 'response code';
    is $res->header('Content-Type'), 'image/png', 'content-type';
    is $res->header('Content-Length'), length($data), 'content-length';
    is $res->content, $data, 'content';
};

subtest 'content-type' => sub {

    my $check_content_type = sub {
        my ($type, $content_type) = @_;

        my $res = $c->render_raw($type => '');
        is $res->header('Content-Type'), $content_type, $content_type;
    };

    my $content_types = {
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
    for my $type ( keys %$content_types ) {
        $check_content_type->($type, $content_types->{$type});
    }
};

subtest 'unsupported type' => sub {
    dies_ok { $c->render_raw(json => '') } 'json is unsupported';
};

done_testing;
