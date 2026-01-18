-- Migration: 029_athlete_diggins.sql
-- Athlete Profile: Jessie Diggins (American Cross-Country Skiing)
-- Created: 2025-01-11

INSERT INTO articles (
    slug,
    title,
    excerpt,
    content,
    category,
    sport_code,
    meta_description,
    status,
    published_at,
    source_type
) VALUES (
    'jessie-diggins-cross-country-profile',
    '{
        "en": "Jessie Diggins: America''s Cross-Country Pioneer",
        "de": "Jessie Diggins: Amerikas Langlauf-Pionierin",
        "fr": "Jessie Diggins: La pionniere americaine du ski de fond",
        "it": "Jessie Diggins: La pioniera americana dello sci di fondo",
        "es": "Jessie Diggins: La pionera americana del esqui de fondo",
        "pt": "Jessie Diggins: A pioneira americana do esqui cross-country",
        "nl": "Jessie Diggins: De Amerikaanse langlauf pionier",
        "ar": "جيسي ديغنز: رائدة التزلج الريفي الأمريكية",
        "ja": "ジェシー・ディギンズ：アメリカのクロスカントリー開拓者",
        "zh": "Jessie Diggins: Meiguo yueye huaxue xianqu",
        "ko": "제시 디긴스: 미국 크로스컨트리의 개척자"
    }'::jsonb,
    '{
        "en": "The American who became the first US cross-country skier to win a World Cup overall title, breaking barriers and inspiring a nation.",
        "de": "Die Amerikanerin, die als erste US-Langlaeuerin einen Gesamtweltcup-Titel gewann und Barrieren durchbrach.",
        "fr": "L''Americaine qui est devenue la premiere skieuse de fond americaine a remporter un titre general de Coupe du monde.",
        "it": "L''americana che e diventata la prima sciatrice di fondo statunitense a vincere un titolo generale di Coppa del Mondo.",
        "es": "La estadounidense que se convirtio en la primera esquiadora de fondo de EEUU en ganar un titulo general de Copa del Mundo.",
        "pt": "A americana que se tornou a primeira esquiadora cross-country dos EUA a ganhar um titulo geral da Copa do Mundo.",
        "nl": "De Amerikaanse die de eerste Amerikaanse langlaufster werd die een algemene Wereldbeker-titel won.",
        "ar": "الأمريكية التي أصبحت أول متزلجة ريفية أمريكية تفوز بلقب كأس العالم العام",
        "ja": "ワールドカップ総合タイトルを獲得した初のアメリカ人クロスカントリースキー選手",
        "zh": "Chengwei shouwei yingling shijie bei zonghe guanjun de Meiguo yueye huaxue xuanshou",
        "ko": "월드컵 종합 타이틀을 획득한 최초의 미국 크로스컨트리 스키 선수"
    }'::jsonb,
    '{
        "en": "<p>Jessie Diggins has transformed American <a href=\"/cross-country-skiing-guide/\">cross-country skiing</a>. In a sport long dominated by European nations, this athlete from Minnesota has proven that Americans can compete at the highest level.</p><h2>Historic 2018 Breakthrough</h2><p>Diggins and teammate Kikkan Randall made history at the 2018 Winter Games with a gold medal in the team sprint. This was the first-ever cross-country skiing medal for the United States, and it was gold. The dramatic finish captured the attention of American sports fans and introduced many to the sport.</p><h2>World Cup Overall Champion</h2><p>In the 2020-21 season, Diggins achieved what no American cross-country skier had done before: she won the overall World Cup title. This season-long achievement required consistent excellence across all race formats and distances. She finished on the podium repeatedly, proving her status among the world''s best.</p><h2>Versatile Racer</h2><p>Diggins excels in multiple disciplines. Her sprinting speed makes her dangerous in short races, while her endurance allows her to compete in distance events. This versatility is essential for overall World Cup success, where points are earned across all formats. She has won races at various distances throughout her career.</p><h2>Competing with the Best</h2><p>Diggins regularly races against legends like <a href=\"/therese-johaug-cross-country-profile/\">Therese Johaug</a> and the strong Norwegian team. While Norway dominates the sport with athletes like <a href=\"/johannes-hoesflot-klaebo-cross-country-profile/\">Johannes Hoesflot Klaebo</a> on the men''s side, Diggins has shown Americans can match Scandinavian excellence.</p><h2>Passionate Advocate</h2><p>Beyond racing, Diggins has been open about her personal struggles, including eating disorders. Her advocacy for mental health and body positivity has inspired many young athletes. She shows that elite athletes face challenges beyond competition and that seeking help is a sign of strength.</p><h2>Minnesota Roots</h2><p>Growing up in Afton, Minnesota, Diggins developed her skills far from the traditional cross-country powerhouses of Scandinavia. Her success proves that talent and dedication can overcome geographic disadvantages. She remains connected to her home community and inspires young skiers across America.</p><h2>Continuing the Mission</h2><p>Diggins continues to race at the highest level while building the sport in America. Each podium finish and each victory brings more attention to cross-country skiing in the United States. Her legacy extends beyond medals to the impact she has on growing the sport.</p>",
        "de": "<p>Jessie Diggins hat den amerikanischen <a href=\"/cross-country-skiing-guide/\">Langlauf</a> transformiert. In einem Sport, der lange von europaeischen Nationen dominiert wurde, hat diese Athletin aus Minnesota bewiesen, dass Amerikaner auf hoechstem Niveau mithalten koennen.</p><h2>Historischer Durchbruch 2018</h2><p>Diggins und Teamkollegin Kikkan Randall schrieben 2018 Geschichte mit Gold im Teamsprint. Dies war die erste Langlauf-Medaille fuer die USA ueberhaupt - und es war Gold.</p><h2>Gesamtweltcup-Siegerin</h2><p>In der Saison 2020-21 erreichte Diggins, was keine amerikanische Langlaeuerin zuvor geschafft hatte: Sie gewann den Gesamtweltcup.</p><h2>Vielseitige Rennfahrerin</h2><p>Diggins ueberzeugt in mehreren Disziplinen. Ihre Sprintgeschwindigkeit macht sie bei kurzen Rennen gefaehrlich.</p><h2>Konkurrenz mit den Besten</h2><p>Diggins tritt regelmaessig gegen Legenden wie <a href=\"/therese-johaug-cross-country-profile/\">Therese Johaug</a> an.</p><h2>Engagierte Fuersprache</h2><p>Ueber das Rennsport hinaus war Diggins offen ueber ihre persoenlichen Kaempfe, einschliesslich Essstoerungen.</p><h2>Minnesota-Wurzeln</h2><p>Aufgewachsen in Afton, Minnesota, entwickelte Diggins ihre Faehigkeiten weit entfernt von den traditionellen Langlauf-Hochburgen.</p><h2>Mission fortsetzen</h2><p>Diggins faehrt weiterhin auf hoechstem Niveau, waehrend sie den Sport in Amerika aufbaut.</p>",
        "fr": "<p>Jessie Diggins a transforme le <a href=\"/cross-country-skiing-guide/\">ski de fond</a> americain. Dans un sport longtemps domine par les nations europeennes, cette athlete du Minnesota a prouve que les Americains peuvent concourir au plus haut niveau.</p><h2>Percee historique en 2018</h2><p>Diggins et sa coequipiere Kikkan Randall ont fait l''histoire en 2018 avec l''or en sprint par equipes.</p><h2>Championne du classement general</h2><p>En 2020-21, Diggins a accompli ce qu''aucune fondeuse americaine n''avait fait: elle a remporte le titre general.</p><h2>Coureuse polyvalente</h2><p>Diggins excelle dans plusieurs disciplines.</p><h2>Concurrence avec les meilleures</h2><p>Diggins court regulierement contre des legendes comme <a href=\"/therese-johaug-cross-country-profile/\">Therese Johaug</a>.</p><h2>Defenseure passionnee</h2><p>Au-dela de la competition, Diggins a ete ouverte sur ses luttes personnelles.</p><h2>Racines du Minnesota</h2><p>Originaire d''Afton, Minnesota, Diggins a developpe ses competences loin des puissances traditionnelles.</p><h2>Poursuivre la mission</h2><p>Diggins continue de courir au plus haut niveau tout en developpant le sport en Amerique.</p>",
        "it": "<p>Jessie Diggins ha trasformato lo <a href=\"/cross-country-skiing-guide/\">sci di fondo</a> americano. In uno sport a lungo dominato dalle nazioni europee, questa atleta del Minnesota ha dimostrato che gli americani possono competere al massimo livello.</p><h2>Svolta storica nel 2018</h2><p>Diggins e la compagna di squadra Kikkan Randall hanno fatto la storia nel 2018 con l''oro nello sprint a squadre.</p><h2>Campionessa della classifica generale</h2><p>Nella stagione 2020-21, Diggins ha raggiunto cio che nessuna fondista americana aveva fatto prima.</p><h2>Atleta versatile</h2><p>Diggins eccelle in piu discipline.</p><h2>Competere con le migliori</h2><p>Diggins gareggia regolarmente contro leggende come <a href=\"/therese-johaug-cross-country-profile/\">Therese Johaug</a>.</p><h2>Sostenitrice appassionata</h2><p>Oltre alle gare, Diggins e stata aperta sulle sue lotte personali.</p><h2>Radici del Minnesota</h2><p>Cresciuta ad Afton, Minnesota, Diggins ha sviluppato le sue abilita lontano dalle potenze tradizionali.</p><h2>Continuare la missione</h2><p>Diggins continua a gareggiare al massimo livello mentre costruisce lo sport in America.</p>",
        "es": "<p>Jessie Diggins ha transformado el <a href=\"/cross-country-skiing-guide/\">esqui de fondo</a> estadounidense. En un deporte dominado por naciones europeas, esta atleta de Minnesota ha demostrado que los estadounidenses pueden competir al mas alto nivel.</p><h2>Avance historico en 2018</h2><p>Diggins y su companera Kikkan Randall hicieron historia en 2018 con oro en sprint por equipos.</p><h2>Campeona del clasificacion general</h2><p>En 2020-21, Diggins logro lo que ninguna fondista estadounidense habia hecho.</p><h2>Corredora versatil</h2><p>Diggins destaca en multiples disciplinas.</p><h2>Competir con las mejores</h2><p>Diggins corre regularmente contra leyendas como <a href=\"/therese-johaug-cross-country-profile/\">Therese Johaug</a>.</p><h2>Defensora apasionada</h2><p>Mas alla de las carreras, Diggins ha sido abierta sobre sus luchas personales.</p><h2>Raices de Minnesota</h2><p>Crecida en Afton, Minnesota, Diggins desarrollo sus habilidades lejos de las potencias tradicionales.</p><h2>Continuar la mision</h2><p>Diggins continua compitiendo al mas alto nivel mientras construye el deporte en America.</p>",
        "pt": "<p>Jessie Diggins transformou o <a href=\"/cross-country-skiing-guide/\">esqui cross-country</a> americano. Em um esporte dominado por nacoes europeias, esta atleta de Minnesota provou que americanos podem competir no mais alto nivel.</p><h2>Avanco historico em 2018</h2><p>Diggins e sua companheira Kikkan Randall fizeram historia em 2018 com ouro no sprint por equipes.</p><h2>Campea da classificacao geral</h2><p>Em 2020-21, Diggins alcancou o que nenhuma esquiadora americana havia feito.</p><h2>Corredora versatil</h2><p>Diggins se destaca em multiplas disciplinas.</p><h2>Competir com as melhores</h2><p>Diggins corre regularmente contra lendas como <a href=\"/therese-johaug-cross-country-profile/\">Therese Johaug</a>.</p><h2>Defensora apaixonada</h2><p>Alem das corridas, Diggins foi aberta sobre suas lutas pessoais.</p><h2>Raizes de Minnesota</h2><p>Crescida em Afton, Minnesota, Diggins desenvolveu suas habilidades longe das potencias tradicionais.</p><h2>Continuar a missao</h2><p>Diggins continua competindo no mais alto nivel enquanto constroi o esporte na America.</p>",
        "nl": "<p>Jessie Diggins heeft het Amerikaanse <a href=\"/cross-country-skiing-guide/\">langlaufen</a> getransformeerd. In een sport die lang gedomineerd werd door Europese landen, heeft deze atlete uit Minnesota bewezen dat Amerikanen op het hoogste niveau kunnen concurreren.</p><h2>Historische doorbraak in 2018</h2><p>Diggins en teamgenoot Kikkan Randall maakten geschiedenis in 2018 met goud in de teamsprint.</p><h2>Algemene Wereldbeker-kampioen</h2><p>In 2020-21 bereikte Diggins wat geen Amerikaanse langlaufster eerder had gedaan.</p><h2>Veelzijdige racer</h2><p>Diggins blinkt uit in meerdere disciplines.</p><h2>Concurreren met de besten</h2><p>Diggins racet regelmatig tegen legendes zoals <a href=\"/therese-johaug-cross-country-profile/\">Therese Johaug</a>.</p><h2>Gepassioneerd pleitbezorger</h2><p>Naast het racen is Diggins open geweest over haar persoonlijke worstelingen.</p><h2>Minnesota-wortels</h2><p>Opgegroeid in Afton, Minnesota, ontwikkelde Diggins haar vaardigheden ver van de traditionele grootmachten.</p><h2>De missie voortzetten</h2><p>Diggins blijft op het hoogste niveau racen terwijl ze de sport in Amerika opbouwt.</p>",
        "ar": "<p>حولت جيسي ديغنز <a href=\"/cross-country-skiing-guide/\">التزلج الريفي</a> الأمريكي. في رياضة هيمنت عليها الدول الأوروبية طويلاً، أثبتت هذه الرياضية من مينيسوتا أن الأمريكيين يمكنهم المنافسة على أعلى مستوى.</p><h2>اختراق تاريخي 2018</h2><p>صنعت ديغنز وزميلتها كيكان راندال التاريخ في 2018 بالذهب في سباق السرعة الجماعي.</p><h2>بطلة الترتيب العام</h2><p>في موسم 2020-21، حققت ديغنز ما لم تحققه أي متزلجة أمريكية من قبل.</p><h2>متسابقة متعددة المواهب</h2><p>تتفوق ديغنز في تخصصات متعددة.</p><h2>المنافسة مع الأفضل</h2><p>تسابق ديغنز بانتظام ضد أساطير مثل <a href=\"/therese-johaug-cross-country-profile/\">تيريز يوهاوج</a>.</p><h2>مناصرة شغوفة</h2><p>بخلاف السباقات، كانت ديغنز منفتحة حول صراعاتها الشخصية.</p><h2>جذور مينيسوتا</h2><p>نشأت في أفتون، مينيسوتا، وطورت مهاراتها بعيداً عن القوى التقليدية.</p><h2>مواصلة المهمة</h2><p>تواصل ديغنز السباق على أعلى مستوى مع بناء الرياضة في أمريكا.</p>",
        "ja": "<p>ジェシー・ディギンズはアメリカの<a href=\"/cross-country-skiing-guide/\">クロスカントリースキー</a>を変革しました。ヨーロッパ諸国が長く支配してきたスポーツで、このミネソタ出身の選手はアメリカ人も最高レベルで競争できることを証明しました。</p><h2>2018年の歴史的突破</h2><p>ディギンズとチームメイトのキッカン・ランドールは2018年にチームスプリントで金メダルを獲得し歴史を作りました。</p><h2>ワールドカップ総合チャンピオン</h2><p>2020-21シーズン、ディギンズはアメリカのクロスカントリースキー選手として初めて総合タイトルを獲得しました。</p><h2>多才なレーサー</h2><p>ディギンズは複数の種目で優れています。</p><h2>最高の選手との競争</h2><p>ディギンズは定期的に<a href=\"/therese-johaug-cross-country-profile/\">テレーセ・ヨーハウグ</a>のような伝説と競います。</p><h2>情熱的な擁護者</h2><p>レース以外でも、ディギンズは個人的な苦闘についてオープンでした。</p><h2>ミネソタのルーツ</h2><p>ミネソタ州アフトンで育ち、伝統的な強豪国から遠く離れてスキルを磨きました。</p><h2>使命の継続</h2><p>ディギンズはアメリカでスポーツを発展させながら最高レベルでレースを続けています。</p>",
        "zh": "<p>Jessie Diggins gaibian le Meiguo <a href=\"/cross-country-skiing-guide/\">yueye huaxue</a>. Zai zhege changqi you Ouzhou guojia zhudao de yundong zhong, zhe wei lai zi Mingnisuoda de yundongyuan zhengming le Meiguo ren keyi zai zuigao shuiping jingzheng.</p><h2>2018 lishixing tupo</h2><p>Diggins he duiyou Kikkan Randall zai 2018 nian tuandui duanpao zhong huode jinpai, chuangzao le lishi.</p><h2>Shijie bei zonghe guanjun</h2><p>Zai 2020-21 saiji, Diggins wancheng le meiyou Meiguo yueye huaxue xuanshou zuodao de shiqing.</p><h2>Duoneng de saiche xuanshou</h2><p>Diggins zai duozhong xiangmu zhong biaoxian chuzhong.</p><h2>Yu zuihao de xuanshou jingzheng</h2><p>Diggins jingchang yu <a href=\"/therese-johaug-cross-country-profile/\">Therese Johaug</a> deng chuanqi bisai.</p><h2>Reqing de changdaozhe</h2><p>Chule bisai, Diggins gongkai le ta de geren douzheng.</p><h2>Mingnisuoda genyuan</h2><p>Zai Mingnisuoda zhou Afton zhangda, ta yuanli chuantong qiangguo fazhan jineng.</p><h2>Jixu shiming</h2><p>Diggins jixu zai zuigao shuiping bisai, tongshi zai Meiguo fazhan zhe xiang yundong.</p>",
        "ko": "<p>제시 디긴스는 미국 <a href=\"/cross-country-skiing-guide/\">크로스컨트리 스키</a>를 변화시켰습니다. 오랫동안 유럽 국가들이 지배해온 스포츠에서 이 미네소타 출신 선수는 미국인도 최고 수준에서 경쟁할 수 있음을 증명했습니다.</p><h2>2018년 역사적 돌파</h2><p>디긴스와 팀 동료 키칸 랜달은 2018년 팀 스프린트에서 금메달을 획득하며 역사를 만들었습니다.</p><h2>월드컵 종합 챔피언</h2><p>2020-21 시즌, 디긴스는 미국 크로스컨트리 스키 선수로서 처음으로 종합 타이틀을 획득했습니다.</p><h2>다재다능한 레이서</h2><p>디긴스는 여러 종목에서 뛰어납니다.</p><h2>최고와의 경쟁</h2><p>디긴스는 정기적으로 <a href=\"/therese-johaug-cross-country-profile/\">테레세 요하우그</a> 같은 전설들과 경쟁합니다.</p><h2>열정적인 옹호자</h2><p>레이스 외에도 디긴스는 개인적인 어려움에 대해 솔직했습니다.</p><h2>미네소타 뿌리</h2><p>미네소타주 애프턴에서 자라며 전통적인 강호들과 멀리 떨어져 기술을 개발했습니다.</p><h2>사명 계속</h2><p>디긴스는 미국에서 스포츠를 발전시키면서 최고 수준에서 레이스를 계속합니다.</p>"
    }'::jsonb,
    'athlete-profile',
    'XC',
    '{
        "en": "Profile of Jessie Diggins, America''s cross-country skiing pioneer who became the first US skier to win a World Cup overall title.",
        "de": "Profil von Jessie Diggins, Amerikas Langlauf-Pionierin, die als erste US-Skierlin den Gesamtweltcup gewann.",
        "fr": "Profil de Jessie Diggins, la pionniere americaine du ski de fond qui est devenue la premiere skieuse americaine a remporter le titre general.",
        "it": "Profilo di Jessie Diggins, la pioniera americana dello sci di fondo che e diventata la prima sciatrice USA a vincere il titolo generale.",
        "es": "Perfil de Jessie Diggins, la pionera americana del esqui de fondo que se convirtio en la primera esquiadora de EEUU en ganar el titulo general.",
        "pt": "Perfil de Jessie Diggins, a pioneira americana do esqui cross-country que se tornou a primeira esquiadora dos EUA a ganhar o titulo geral.",
        "nl": "Profiel van Jessie Diggins, de Amerikaanse langlauf pionier die de eerste Amerikaanse skiester werd die de algemene titel won.",
        "ar": "ملف جيسي ديغنز، رائدة التزلج الريفي الأمريكية التي أصبحت أول متزلجة أمريكية تفوز باللقب العام.",
        "ja": "ワールドカップ総合タイトルを獲得した初のアメリカ人スキー選手、アメリカのクロスカントリー開拓者ジェシー・ディギンズのプロフィール。",
        "zh": "Jessie Diggins de jianjie, chengwei shouge yingling shijie bei zonghe guanjun de Meiguo yueye huaxue xianqu.",
        "ko": "월드컵 종합 타이틀을 획득한 최초의 미국 스키 선수가 된 미국 크로스컨트리의 개척자 제시 디긴스의 프로필."
    }'::jsonb,
    'published',
    NOW(),
    'evergreen'
) ON CONFLICT (slug) DO UPDATE SET
    title = EXCLUDED.title,
    excerpt = EXCLUDED.excerpt,
    content = EXCLUDED.content,
    meta_description = EXCLUDED.meta_description,
    updated_at = NOW();

-- Track image requirement
INSERT INTO article_images (article_slug, image_type, description, status)
VALUES (
    'jessie-diggins-cross-country-profile',
    'featured',
    'Jessie Diggins skiing with determination, American team uniform, snowy trail background',
    'pending'
) ON CONFLICT (article_slug, image_type) DO NOTHING;
