#!/bin/bash
FILE="$1"

cat <<EOF
<?xml version="1.0" encoding="UTF-8" ?>
<rss version="2.0">
<channel>
 <title>HHGTTG</title>
 <description>HHGTTG</description>
 <language>en-us</language>
 <copyright>bbc</copyright>
 <link>https://erikmartino.github.io/</link>
 <image>
   <url>https://erikmartino.github.io/favicon.png</url>
   <link>https://erikmartino.github.io/</link>
   <title>HHGTTG</title>
 </image>
 <generator>m3u2rss.sh</generator>
 <ttl>263520</ttl>
 <lastBuildDate>$(date -R)</lastBuildDate>
 <pubDate>$(date -R)</pubDate>
EOF

cat "$FILE" |
	tr -d '\r' |
	egrep -v '^#' |
	egrep -v '^$' |
while read l; do
	cat <<END
	<item>
		<link>$l</link>
		<guid>$l</guid>
		<description>$(echo $l | sed -e 's!.*/!!' -e 's/%20/ /g' -e 's/.mp3$//')</description>
		<pubDate>$(date -R)</pubDate>
		<enclosure url="$l" type="audio/mpeg" length="$(curl -sLI $l | grep Content-Length: | awk '{print $2}' | tr -d '\r\n')" />
	</item>
END
done

cat <<EOF
</channel>
</rss>
EOF
