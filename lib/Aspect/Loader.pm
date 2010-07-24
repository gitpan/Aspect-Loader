package Aspect::Loader;
use 5.008008;
use strict;
use warnings;
our $VERSION = '0.01';
use Aspect;
use Aspect::Loader::Configuration::YAML;
use Aspect::Loader::Definition;
use UNIVERSAL::require;
use Class::Inspector;

sub new{
	my $class     = shift;
	my $configuration  = shift;
	my $self = {
		_configuration => $configuration,
	};
	bless $self,$class;
  $self->load_aspect;
	return $self;
}

sub yaml_loader{
	my $class = shift;
	my $file_path = shift;
	my $configuration = Aspect::Loader::Configuration::YAML->new($file_path);
	return $class->new($configuration);
}

sub load_aspect{
	my $self = shift;
  my $configuration = $self->{_configuration}->get_configuration();
  foreach my $conf (@$configuration){
	    my $definition = Aspect::Loader::Definition->new($conf);
      my $class = $definition->get_class_name;
      unless(Class::Inspector->loaded($class )){
        $class->require or die "cant load class $class";
      }
      if($definition->get_class_name){

      }
      aspect $definition->get_library  => $definition->get_call;
  }
}


1;
__END__

=head1 NAME

Class::DI - Perl dependency injection container

=head1 SYNOPSIS
configuration by yaml 

injections:
 - name: hoge
   class_name: Hoge
   injection_type: setter
   instance_type: prototype
   properties:
     name: hoge
 - name: fuga
   class_name: Fuga
   injection_type: constructer
   instance_type: singleton
   properties:
     name: fuga
 - name: hogehoge
   class_name: HogeHoge
   injection_type: constructer
   instance_type: singleton
   properties:
     hogehoge: 
       name: fugafuga
       class_name: FugaFuga
       injection_type: constructer
       instance_type: singleton
       properties:
         name: fugafuga


  my $di = Class::DI->yaml_container($yaml_filepath);
  # set from set_name method
  # $hoge->set_name("hoge"); 
  my $hoge = $di->get_component("hoge"); 
  print $hoge->get_name; # hoge

  # set from constructer 
	# Fuga->new({name=>"fuga"});
	my $fuga = $di->get_component("fuga"); 
  print $fuga->get_name; # fuga

	# nested class 
	my $hogehoge = $di->get_component("hogehoge"); 
  print $hogehoge->get_fugafuga->get_name; # fugafuga

=head1 DESCRIPTION

this class does DI. The instance is generated based on an external setting,
 and the dependence between components is excluded from the source code. 

=head1 SEE ALSO


=head1 AUTHOR

Masafumi Yoshida, E<lt>masafumi.yoshida820@gmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by masafumi yoshida

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.


=cut
