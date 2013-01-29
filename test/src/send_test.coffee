describe 'XMLHttpRequest', ->
  describe '#send', ->
    beforeEach ->
      @xhr = new XMLHttpRequest
      @xhr.open 'POST', 'https://localhost:8911/_/echo'

      @arrayBuffer = new ArrayBuffer xhr2PngBytes.length
      @arrayBufferView = new Uint8Array @arrayBuffer
      if typeof Buffer is 'undefined'
        @buffer = null
      else
        @buffer = new Buffer xhr2PngBytes.length

      for i in [0...xhr2PngBytes.length]
        @arrayBufferView[i] = xhr2PngBytes[i]
        @buffer.writeUInt8 xhr2PngBytes[i], i if @buffer

    it 'works with ASCII DOMStrings', (done) ->
      @xhr.onload = =>
        expect(@xhr.getResponseHeader('content-type')).to.
            match(/^text\/plain(;\s?charset=UTF-8)?$/)
        expect(@xhr.responseText).to.equal 'Hello world!'
        done()
      @xhr.send "Hello world!"

    it 'works with UTF-8 DOMStrings', (done) ->
      @xhr.onloadend = =>
        expect(@xhr.getResponseHeader('content-type')).to.
            match(/^text\/plain(;\s?charset=UTF-8)?$/)
        expect(@xhr.responseText).to.equal '世界你好!'
        done()
      @xhr.send '世界你好!'

    it 'works with ArrayBufferViews', (done) ->
      @xhr.responseType = 'arraybuffer'
      @xhr.onload = =>
        expect(@xhr.getResponseHeader('content-type')).to.equal null
        responseView = new Uint8Array @xhr.response
        responseBytes = (responseView[i] for i in [0...responseView.length])
        expect(responseBytes).to.deep.equal xhr2PngBytes
        done()
      @xhr.send @arrayBufferView

    it 'works with ArrayBuffers', (done) ->
      @xhr.responseType = 'arraybuffer'
      @xhr.onload = =>
        expect(@xhr.getResponseHeader('content-type')).to.equal null
        responseView = new Uint8Array @xhr.response
        responseBytes = (responseView[i] for i in [0...responseView.length])
        expect(responseBytes).to.deep.equal xhr2PngBytes
        done()
      @xhr.send @arrayBuffer

    it 'works with node.js Buffers', (done) ->
      return done() unless @buffer
      # NOTE: using the same exact code as above, which is tested in a browser
      @xhr.responseType = 'arraybuffer'
      @xhr.onload = =>
        expect(@xhr.getResponseHeader('content-type')).to.equal null
        responseView = new Uint8Array @xhr.response
        responseBytes = (responseView[i] for i in [0...responseView.length])
        expect(responseBytes).to.deep.equal xhr2PngBytes
        done()
      @xhr.send @buffer

