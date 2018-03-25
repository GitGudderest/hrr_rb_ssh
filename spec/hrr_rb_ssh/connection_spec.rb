# coding: utf-8
# vim: et ts=2 sw=2

RSpec.describe HrrRbSsh::Connection do
  describe '.new' do
    let(:io){ 'dummy' }
    let(:mode){ 'dummy' }
    let(:transport){ HrrRbSsh::Transport.new io, mode }
    let(:authentication){ HrrRbSsh::Authentication.new transport }
    let(:options){ Hash.new }

    it "can take one argument: authentication" do
      expect { described_class.new(authentication) }.not_to raise_error
    end

    it "can take two arguments: authentication and options" do
      expect { described_class.new(authentication, options) }.not_to raise_error
    end
  end

  describe '#start' do
    let(:io){ 'dummy' }
    let(:mode){ 'dummy' }
    let(:transport){ HrrRbSsh::Transport.new io, mode }
    let(:authentication){ HrrRbSsh::Authentication.new transport }
    let(:options){ Hash.new }
    let(:connection){ described_class.new authentication, options }

    it "calls authentication.start and start_connection_loop" do
      expect(authentication).to receive(:start).with(no_args).once
      expect(connection).to receive(:start_connection_loop).with(no_args).once
      connection.start
    end
  end

  describe '#start_connection_loop' do
    let(:io){ 'dummy' }
    let(:mode){ 'dummy' }
    let(:transport){ HrrRbSsh::Transport.new io, mode }
    let(:authentication){ HrrRbSsh::Authentication.new transport }
    let(:options){ Hash.new }
    let(:connection){ described_class.new authentication, options }

    context "when receives channel open message" do
      let(:channel_open_message){
        {
          "SSH_MSG_CHANNEL_OPEN" => HrrRbSsh::Message::SSH_MSG_CHANNEL_OPEN::VALUE,
          "channel type"         => "session",
          "sender channel"       => 0,
          "initial window size"  => 2097152,
          "maximum packet size"  => 32768,
        }
      }
      let(:channel_open_payload){
        HrrRbSsh::Message::SSH_MSG_CHANNEL_OPEN.encode channel_open_message
      }

      it "calls channel_open" do
        expect(authentication).to receive(:receive).with(no_args).and_return(channel_open_payload).once
        expect(authentication).to receive(:receive).with(no_args).and_return(nil).once
        expect(connection).to receive(:channel_open).with(channel_open_payload).once
        connection.start_connection_loop
      end
    end
  end

  describe '#channel_open' do
    let(:io){ 'dummy' }
    let(:mode){ 'dummy' }
    let(:transport){ HrrRbSsh::Transport.new io, mode }
    let(:authentication){ HrrRbSsh::Authentication.new transport }
    let(:options){ Hash.new }
    let(:connection){ described_class.new authentication, options }

    context "when receives valid channel open message" do
      let(:channel_open_message){
        {
          "SSH_MSG_CHANNEL_OPEN" => HrrRbSsh::Message::SSH_MSG_CHANNEL_OPEN::VALUE,
          "channel type"         => "session",
          "sender channel"       => 0,
          "initial window size"  => 2097152,
          "maximum packet size"  => 32768,
        }
      }
      let(:channel_open_payload){
        HrrRbSsh::Message::SSH_MSG_CHANNEL_OPEN.encode channel_open_message
      }
      let(:channel_open_confirmation_message){
        {
          "SSH_MSG_CHANNEL_OPEN_CONFIRMATION" => HrrRbSsh::Message::SSH_MSG_CHANNEL_OPEN_CONFIRMATION::VALUE,
          "channel type"                      => "session",
          "recipient channel"                 => 0,
          "sender channel"                    => 0,
          "initial window size"               => 2097152,
          "maximum packet size"               => 32768,
        }
      }
      let(:channel_open_confirmation_payload){
        HrrRbSsh::Message::SSH_MSG_CHANNEL_OPEN_CONFIRMATION.encode channel_open_confirmation_message
      }

      it "calls channel_open" do
        expect(authentication).to receive(:send).with(channel_open_confirmation_payload).once
        connection.channel_open channel_open_payload
        expect(connection.instance_variable_get('@channels')).to include(channel_open_message['sender channel'])
      end
    end
  end
end