{%- if page.layout == 'post' and page.comments !== false %}
  <section class="comments" id="utterances-comments">
    <script src="https://utteranc.es/client.js"
            repo="stubborn123/stubborn123.github.io"
            issue-term="pathname"
            label="comment"
            theme="preferred-color-scheme"
            crossorigin="anonymous"
            async>
    </script>
  </section>
{%- endif %}
