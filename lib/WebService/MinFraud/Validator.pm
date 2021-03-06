package WebService::MinFraud::Validator;

use Moo;
use namespace::autoclean;

our $VERSION = '1.007001';

use Data::Delete 0.05;
use Data::Rx;
use Try::Tiny;
use Types::Standard qw( HashRef InstanceOf Object );
use WebService::MinFraud::Data::Rx::Type::CCToken;
use WebService::MinFraud::Data::Rx::Type::CustomInputs;
use WebService::MinFraud::Data::Rx::Type::DateTime::RFC3339;
use WebService::MinFraud::Data::Rx::Type::Enum;
use WebService::MinFraud::Data::Rx::Type::Hex32;
use WebService::MinFraud::Data::Rx::Type::Hostname;
use WebService::MinFraud::Data::Rx::Type::IPAddress;
use WebService::MinFraud::Data::Rx::Type::WebURI;

has _deleter => (
    is      => 'lazy',
    isa     => InstanceOf ['Data::Delete'],
    builder => sub { Data::Delete->new },
    handles => { _delete => 'delete' },
);

has _request_schema_definition => (
    is      => 'lazy',
    isa     => HashRef,
    builder => '_build_request_schema_definition',
);

has _rx => (
    is      => 'lazy',
    isa     => InstanceOf ['Data::Rx'],
    builder => sub {
        Data::Rx->new(
            {
                prefix => {
                    maxmind => 'tag:maxmind.com,MAXMIND:rx/',
                },
                type_plugins => [
                    qw(
                        WebService::MinFraud::Data::Rx::Type::CCToken
                        WebService::MinFraud::Data::Rx::Type::CustomInputs
                        WebService::MinFraud::Data::Rx::Type::DateTime::RFC3339
                        WebService::MinFraud::Data::Rx::Type::Enum
                        WebService::MinFraud::Data::Rx::Type::Hex32
                        WebService::MinFraud::Data::Rx::Type::Hostname
                        WebService::MinFraud::Data::Rx::Type::IPAddress
                        WebService::MinFraud::Data::Rx::Type::WebURI
                        )
                ],
            },
        );
    },
);

has _schema => (
    is      => 'lazy',
    isa     => Object,
    builder => sub {
        my $self = shift;
        $self->_rx->make_schema( $self->_request_schema_definition );
    },
);

sub _build_request_schema_definition {
    return {
        type     => '//rec',
        required => {
            device => {
                type     => '//rec',
                required => {
                    ip_address => {
                        type => '/maxmind/ip',
                    },
                },
                optional => {
                    user_agent      => '//str',
                    accept_language => '//str',
                    session_age     => '//num',
                    session_id      => {
                        type   => '//str',
                        length => { min => 1, max => 255, },
                    },
                },
            },
        },
        optional => {
            account => {
                type     => '//rec',
                optional => {
                    user_id      => '//str',
                    username_md5 => '/maxmind/hex32',
                },
            },
            billing => {
                type     => '//rec',
                optional => {
                    first_name => '//str',
                    last_name  => '//str',
                    company    => '//str',
                    address    => '//str',
                    address_2  => '//str',
                    city       => '//str',
                    region     => {
                        type   => '//str',
                        length => { 'min' => 1, 'max' => 4 },
                    },
                    country => {
                        type   => '//str',
                        length => { 'min' => 2, 'max' => 2 },
                    },
                    postal             => '//str',
                    phone_number       => '//str',
                    phone_country_code => '//int',
                },
            },
            credit_card => {
                type     => '//rec',
                optional => {
                    avs_result => {
                        type   => '//str',
                        length => { 'min' => 1, 'max' => 1 },
                    },
                    bank_name               => '//str',
                    bank_phone_country_code => '//int',
                    bank_phone_number       => '//str',
                    cvv_result              => {
                        type   => '//str',
                        length => { 'min' => 1, 'max' => 1 },
                    },
                    issuer_id_number => {
                        type   => '//str',
                        length => { 'min' => 6, 'max' => 6 },
                    },
                    last_4_digits => {
                        type   => '//str',
                        length => { 'min' => 4, 'max' => 4 },
                    },
                    token => '/maxmind/cctoken',
                },
            },
            custom_inputs => {
                type => '/maxmind/custom_inputs',
            },
            email => {
                type     => '//rec',
                optional => {
                    address => '//str',
                    domain  => '/maxmind/hostname',
                },
            },
            event => {
                type     => '//rec',
                optional => {
                    transaction_id => '//str',
                    shop_id        => '//str',
                    time           => '/maxmind/datetime/rfc3339',
                    type           => {
                        type     => '/maxmind/enum',
                        contents => {
                            type   => '//str',
                            values => [
                                'account_creation',
                                'account_login',
                                'email_change',
                                'password_reset',
                                'payout_change',
                                'purchase',
                                'recurring_purchase',
                                'referral',
                                'survey',
                            ],
                        },
                    },
                },
            },
            order => {
                type     => '//rec',
                optional => {
                    amount   => '//num',
                    currency => {
                        type   => '//str',
                        length => { 'min' => 3, 'max' => 3 },
                    },
                    discount_code    => '//str',
                    affiliate_id     => '//str',
                    subaffiliate_id  => '//str',
                    referrer_uri     => '/maxmind/weburi',
                    is_gift          => '//bool',
                    has_gift_message => '//bool',
                },
            },
            payment => {
                type     => '//rec',
                optional => {
                    processor => {
                        type     => '/maxmind/enum',
                        contents => {
                            type   => '//str',
                            values => [
                                'adyen',
                                'altapay',
                                'amazon_payments',
                                'american_express_payment_gateway',
                                'authorizenet',
                                'balanced',
                                'beanstream',
                                'bluepay',
                                'bluesnap',
                                'bpoint',
                                'braintree',
                                'ccavenue',
                                'ccnow',
                                'chase_paymentech',
                                'checkout_com',
                                'cielo',
                                'collector',
                                'commdoo',
                                'compropago',
                                'concept_payments',
                                'conekta',
                                'ct_payments',
                                'cuentadigital',
                                'curopayments',
                                'cybersource',
                                'dalenys',
                                'dalpay',
                                'dibs',
                                'digital_river',
                                'ebs',
                                'ecomm365',
                                'elavon',
                                'emerchantpay',
                                'epay',
                                'eprocessing_network',
                                'eway',
                                'exact',
                                'first_data',
                                'global_payments',
                                'heartland',
                                'hipay',
                                'ingenico',
                                'internetsecure',
                                'intuit_quickbooks_payments',
                                'iugu',
                                'lemon_way',
                                'mastercard_payment_gateway',
                                'mercadopago',
                                'merchant_esolutions',
                                'mirjeh',
                                'mollie',
                                'moneris_solutions',
                                'nmi',
                                'oceanpayment',
                                'oney',
                                'openpaymx',
                                'optimal_payments',
                                'orangepay',
                                'other',
                                'pacnet_services',
                                'payfast',
                                'paygate',
                                'paymentwall',
                                'payone',
                                'paypal',
                                'payplus',
                                'paystation',
                                'paytrace',
                                'paytrail',
                                'payture',
                                'payu',
                                'payulatam',
                                'payway',
                                'payza',
                                'pinpayments',
                                'posconnect',
                                'princeton_payment_solutions',
                                'psigate',
                                'qiwi',
                                'quickpay',
                                'raberil',
                                'rede',
                                'redpagos',
                                'rewardspay',
                                'sagepay',
                                'securetrading',
                                'simplify_commerce',
                                'skrill',
                                'smartcoin',
                                'solidtrust_pay',
                                'sps_decidir',
                                'stripe',
                                'telerecargas',
                                'towah',
                                'transact_pro',
                                'usa_epay',
                                'vantiv',
                                'verepay',
                                'vericheck',
                                'vindicia',
                                'virtual_card_services',
                                'vme',
                                'vpos',
                                'wirecard',
                                'worldpay',
                            ],

                        },
                    },
                    was_authorized => '//bool',
                    decline_code   => '//str',
                },
            },
            shipping => {
                type     => '//rec',
                optional => {
                    first_name     => '//str',
                    last_name      => '//str',
                    company        => '//str',
                    address        => '//str',
                    address_2      => '//str',
                    city           => '//str',
                    delivery_speed => {
                        type     => '/maxmind/enum',
                        contents => {
                            type   => '//str',
                            values => [
                                'same_day',  'overnight',
                                'expedited', 'standard',
                            ],
                        },
                    },
                    region => {
                        type   => '//str',
                        length => { 'min' => 1, 'max' => 4 },
                    },
                    country => {
                        type   => '//str',
                        length => { 'min' => 2, 'max' => 2 },
                    },
                    postal             => '//str',
                    phone_number       => '//str',
                    phone_country_code => {
                        type   => '//str',
                        length => { 'min' => 1, 'max' => 4 },
                    },
                },
            },
            shopping_cart => {
                type     => '//arr',
                contents => {
                    type     => '//rec',
                    optional => {
                        category => '//str',
                        item_id  => '//str',
                        quantity => '//int',
                        price    => '//num',
                    },
                },
            },
        },
    };
}

sub validate_request {
    my ( $self, $request ) = @_;
    try {
        $self->_schema->assert_valid($request);
    }
    catch {
        my @error_strings = map {
                  'VALUE: '
                . ( defined $_->value ? $_->value : 'undef' )
                . ' caused ERROR: '
                . $_->stringify
        } @{ $_->failures };
        my $all_error_strings = join "\n", @error_strings;
        die $all_error_strings;
    };
}

1;

# ABSTRACT: Validation for the minFraud requests

__END__

=head1 SYNOPSIS

    use 5.010;

    use WebService::MinFraud::Validator;

    my $validator = WebService::MinFraud::Validator->new;
    my $request = { device => { ip_address => '24.24.24.24' } };
    $validator->validate_request($request);

=head1 DESCRIPTION

This module defines the request schema for the minFraud API. In addition, it
provides a C<validate_request> method that is used to validate any request
passed to the C<score>, C<insights>, or C<factors> methods.

=head1 METHODS

=head2 validate_request

This method takes a minFraud request as a HashRef and validates it against the
minFraud request schema. If the request HashRef fails validation, an exception
is thrown, which is a string containing all of the validation errors.
