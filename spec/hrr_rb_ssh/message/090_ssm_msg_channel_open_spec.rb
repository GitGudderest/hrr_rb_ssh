# coding: utf-8
# vim: et ts=2 sw=2

RSpec.describe HrrRbSsh::Message::SSH_MSG_CHANNEL_OPEN do
  let(:id){ 'SSH_MSG_CHANNEL_OPEN' }
  let(:value){ 90 }

  describe "::ID" do
    it "is defined" do
      expect(described_class::ID).to eq id
    end
  end

  describe "::VALUE" do
    it "is defined" do
      expect(described_class::VALUE).to eq value
    end
  end

  context "when 'channel type' is \"session\"" do
    let(:message){
      {
        id                    => value,
        'channel type'        => 'session',
        'sender channel'      => 1,
        'initial window size' => 2,
        'maximum packet size' => 3,
      }
    }
    let(:payload){
      [
        HrrRbSsh::Transport::DataType::Byte.encode(message[id]),
        HrrRbSsh::Transport::DataType::String.encode(message['channel type']),
        HrrRbSsh::Transport::DataType::Uint32.encode(message['sender channel']),
        HrrRbSsh::Transport::DataType::Uint32.encode(message['initial window size']),
        HrrRbSsh::Transport::DataType::Uint32.encode(message['maximum packet size']),
      ].join
    }

    describe ".encode" do
      it "returns payload encoded" do
        expect(described_class.encode(message)).to eq payload
      end
    end

    describe ".decode" do
      it "returns message decoded" do
        expect(described_class.decode(payload)).to eq message
      end
    end
  end

  context "when 'channel type' is \"x11\"" do
    let(:message){
      {
        id                    => value,
        'channel type'        => 'x11',
        'sender channel'      => 1,
        'initial window size' => 2,
        'maximum packet size' => 3,
        'originator address'  => '1.2.3.4',
        'originator port'     => 12345,
      }
    }
    let(:payload){
      [
        HrrRbSsh::Transport::DataType::Byte.encode(message[id]),
        HrrRbSsh::Transport::DataType::String.encode(message['channel type']),
        HrrRbSsh::Transport::DataType::Uint32.encode(message['sender channel']),
        HrrRbSsh::Transport::DataType::Uint32.encode(message['initial window size']),
        HrrRbSsh::Transport::DataType::Uint32.encode(message['maximum packet size']),
        HrrRbSsh::Transport::DataType::String.encode(message['originator address']),
        HrrRbSsh::Transport::DataType::Uint32.encode(message['originator port']),
      ].join
    }

    describe ".encode" do
      it "returns payload encoded" do
        expect(described_class.encode(message)).to eq payload
      end
    end

    describe ".decode" do
      it "returns message decoded" do
        expect(described_class.decode(payload)).to eq message
      end
    end
  end

  context "when 'channel type' is \"forwarded-tcpip\"" do
    let(:message){
      {
        id                           => value,
        'channel type'               => 'forwarded-tcpip',
        'sender channel'             => 1,
        'initial window size'        => 2,
        'maximum packet size'        => 3,
        'address that was connected' => '4.3.2.1',
        'port that was connected'    => 54321,
        'originator IP address'      => '1.2.3.4',
        'originator port'            => 12345,
      }
    }
    let(:payload){
      [
        HrrRbSsh::Transport::DataType::Byte.encode(message[id]),
        HrrRbSsh::Transport::DataType::String.encode(message['channel type']),
        HrrRbSsh::Transport::DataType::Uint32.encode(message['sender channel']),
        HrrRbSsh::Transport::DataType::Uint32.encode(message['initial window size']),
        HrrRbSsh::Transport::DataType::Uint32.encode(message['maximum packet size']),
        HrrRbSsh::Transport::DataType::String.encode(message['address that was connected']),
        HrrRbSsh::Transport::DataType::Uint32.encode(message['port that was connected']),
        HrrRbSsh::Transport::DataType::String.encode(message['originator IP address']),
        HrrRbSsh::Transport::DataType::Uint32.encode(message['originator port']),
      ].join
    }

    describe ".encode" do
      it "returns payload encoded" do
        expect(described_class.encode(message)).to eq payload
      end
    end

    describe ".decode" do
      it "returns message decoded" do
        expect(described_class.decode(payload)).to eq message
      end
    end
  end

  context "when 'channel type' is \"direct-tcpip\"" do
    let(:message){
      {
        id                      => value,
        'channel type'          => 'direct-tcpip',
        'sender channel'        => 1,
        'initial window size'   => 2,
        'maximum packet size'   => 3,
        'host to connect'       => '4.3.2.1',
        'port to connect'       => 54321,
        'originator IP address' => '1.2.3.4',
        'originator port'       => 12345,
      }
    }
    let(:payload){
      [
        HrrRbSsh::Transport::DataType::Byte.encode(message[id]),
        HrrRbSsh::Transport::DataType::String.encode(message['channel type']),
        HrrRbSsh::Transport::DataType::Uint32.encode(message['sender channel']),
        HrrRbSsh::Transport::DataType::Uint32.encode(message['initial window size']),
        HrrRbSsh::Transport::DataType::Uint32.encode(message['maximum packet size']),
        HrrRbSsh::Transport::DataType::String.encode(message['host to connect']),
        HrrRbSsh::Transport::DataType::Uint32.encode(message['port to connect']),
        HrrRbSsh::Transport::DataType::String.encode(message['originator IP address']),
        HrrRbSsh::Transport::DataType::Uint32.encode(message['originator port']),
      ].join
    }

    describe ".encode" do
      it "returns payload encoded" do
        expect(described_class.encode(message)).to eq payload
      end
    end

    describe ".decode" do
      it "returns message decoded" do
        expect(described_class.decode(payload)).to eq message
      end
    end
  end
end
