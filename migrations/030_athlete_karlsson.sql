-- Migration: 030_athlete_karlsson.sql
-- Athlete Profile: Frida Karlsson (Swedish Cross-Country Skiing)
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
    'frida-karlsson-cross-country-profile',
    '{
        "en": "Frida Karlsson: Sweden''s Cross-Country Rising Star",
        "de": "Frida Karlsson: Schwedens aufgehender Langlauf-Stern",
        "fr": "Frida Karlsson: L''etoile montante suedoise du ski de fond",
        "it": "Frida Karlsson: La stella nascente svedese dello sci di fondo",
        "es": "Frida Karlsson: La estrella emergente sueca del esqui de fondo",
        "pt": "Frida Karlsson: A estrela em ascensao sueca do esqui cross-country",
        "nl": "Frida Karlsson: De rijzende Zweedse langlaufster",
        "ar": "فريدا كارلسون: نجمة التزلج الريفي السويدية الصاعدة",
        "ja": "フリーダ・カールソン：スウェーデンのクロスカントリー新星",
        "zh": "Frida Karlsson: Ruidian yueye huaxue xinxing",
        "ko": "프리다 칼손: 스웨덴 크로스컨트리의 떠오르는 스타"
    }'::jsonb,
    '{
        "en": "The young Swedish cross-country skier who burst onto the World Cup scene with stunning performances and fierce competitive spirit.",
        "de": "Die junge schwedische Langlaeuerin, die mit atemberaubenden Leistungen und unbaendigem Kampfgeist auf die Weltcup-Buehne stuermte.",
        "fr": "La jeune fondeuse suedoise qui a fait irruption sur la scene de la Coupe du monde avec des performances impressionnantes.",
        "it": "La giovane fondista svedese che ha fatto irruzione sulla scena della Coppa del Mondo con prestazioni straordinarie.",
        "es": "La joven esquiadora de fondo sueca que irrumpio en la escena de la Copa del Mundo con actuaciones impresionantes.",
        "pt": "A jovem esquiadora cross-country sueca que explodiu na cena da Copa do Mundo com performances impressionantes.",
        "nl": "De jonge Zweedse langlaufster die op het Wereldbeker-toneel brak met verbluffende prestaties.",
        "ar": "المتزلجة السويدية الشابة التي اقتحمت مشهد كأس العالم بأداء مذهل",
        "ja": "驚異的なパフォーマンスでワールドカップシーンに登場した若いスウェーデンのクロスカントリースキー選手",
        "zh": "Yi jingyan biaoxian chuxian zai shijie bei wutai de nianqing Ruidian yueye huaxue xuanshou",
        "ko": "놀라운 성과로 월드컵 무대에 등장한 젊은 스웨덴 크로스컨트리 스키 선수"
    }'::jsonb,
    '{
        "en": "<p>Frida Karlsson represents the next generation of Swedish <a href=\"/cross-country-skiing-guide/\">cross-country skiing</a> excellence. The young talent has already achieved results that place her among the world''s elite, and she continues to improve each season.</p><h2>Breakthrough at Worlds</h2><p>Karlsson announced herself on the world stage at the 2019 World Championships in Seefeld. At just 19 years old, she captured silver in the 10km freestyle and bronze in the 30km skiathlon. These results signaled that a new star had arrived in the sport.</p><h2>Fearless Racing Style</h2><p>What sets Karlsson apart is her willingness to take risks. She goes out hard from the start, often leading races from the front. This aggressive approach has led to spectacular victories and the occasional blown race when she pushes too hard. Fans love her exciting racing style.</p><h2>Distance Specialist</h2><p>Karlsson excels in longer distance events where her endurance and strength shine. The 10km and 30km races suit her abilities perfectly. She has the physical capacity to maintain high speeds over extended periods, making her dangerous in any distance race.</p><h2>Swedish Skiing Tradition</h2><p>Sweden has a proud history in cross-country skiing, and Karlsson continues this tradition. She trains with a strong Swedish team and has learned from experienced coaches and teammates. This support system helps her develop while competing against the best in the world.</p><h2>Rivalry with Norway</h2><p>Some of Karlsson''s most memorable races have come against Norwegian rivals. Competing against legends like <a href=\"/therese-johaug-cross-country-profile/\">Therese Johaug</a> has pushed her to higher levels. These head-to-head battles create compelling storylines throughout the season.</p><h2>Mental Toughness</h2><p>Karlsson has shown remarkable mental strength. After setbacks, she comes back stronger. Her determination to improve and willingness to learn from defeats make her a formidable competitor. Each season brings noticeable improvements in her technique and race management.</p><h2>Future Potential</h2><p>At her young age, Karlsson has years of development ahead. Her current results already place her among the world''s best, but there is room for continued growth. Swedish fans anticipate many more victories and championship medals in her future.</p>",
        "de": "<p>Frida Karlsson repraesentiert die naechste Generation schwedischer <a href=\"/cross-country-skiing-guide/\">Langlauf</a>-Exzellenz. Das junge Talent hat bereits Ergebnisse erzielt, die sie unter die Weltelite platzieren.</p><h2>Durchbruch bei der WM</h2><p>Karlsson kuendigte sich bei der WM 2019 in Seefeld auf der Weltbuehne an. Mit nur 19 Jahren holte sie Silber ueber 10km und Bronze im 30km Skiathlon.</p><h2>Furchtloser Rennstil</h2><p>Was Karlsson auszeichnet, ist ihre Bereitschaft, Risiken einzugehen. Sie startet hart von Beginn an.</p><h2>Distanzspezialistin</h2><p>Karlsson ueberzeugt bei laengeren Distanzen, wo ihre Ausdauer und Staerke glaenzen.</p><h2>Schwedische Skitradition</h2><p>Schweden hat eine stolze Geschichte im Langlauf, und Karlsson setzt diese Tradition fort.</p><h2>Rivalitaet mit Norwegen</h2><p>Einige von Karlssons denkwuerdigsten Rennen kamen gegen norwegische Rivalinnen wie <a href=\"/therese-johaug-cross-country-profile/\">Therese Johaug</a>.</p><h2>Mentale Staerke</h2><p>Karlsson hat bemerkenswerte mentale Staerke gezeigt.</p><h2>Zukunftspotenzial</h2><p>In ihrem jungen Alter hat Karlsson noch Jahre der Entwicklung vor sich.</p>",
        "fr": "<p>Frida Karlsson represente la prochaine generation d''excellence suedoise en <a href=\"/cross-country-skiing-guide/\">ski de fond</a>. La jeune talentueuse a deja obtenu des resultats qui la placent parmi l''elite mondiale.</p><h2>Percee aux Mondiaux</h2><p>Karlsson s''est annoncee sur la scene mondiale aux Championnats du monde 2019 a Seefeld. A seulement 19 ans, elle a capture l''argent sur 10km et le bronze sur 30km skiathlon.</p><h2>Style de course intrepide</h2><p>Ce qui distingue Karlsson, c''est sa volonte de prendre des risques.</p><h2>Specialiste des distances</h2><p>Karlsson excelle dans les epreuves de longue distance.</p><h2>Tradition suedoise du ski</h2><p>La Suede a une fiere histoire en ski de fond, et Karlsson poursuit cette tradition.</p><h2>Rivalite avec la Norvege</h2><p>Certaines des courses les plus memorables de Karlsson ont ete contre des rivales norvegiennes comme <a href=\"/therese-johaug-cross-country-profile/\">Therese Johaug</a>.</p><h2>Force mentale</h2><p>Karlsson a montre une force mentale remarquable.</p><h2>Potentiel futur</h2><p>A son jeune age, Karlsson a des annees de developpement devant elle.</p>",
        "it": "<p>Frida Karlsson rappresenta la prossima generazione di eccellenza svedese nello <a href=\"/cross-country-skiing-guide/\">sci di fondo</a>. La giovane talento ha gia ottenuto risultati che la collocano tra l''elite mondiale.</p><h2>Svolta ai Mondiali</h2><p>Karlsson si e presentata sulla scena mondiale ai Mondiali 2019 di Seefeld. A soli 19 anni, ha conquistato l''argento nei 10km e il bronzo nello skiathlon 30km.</p><h2>Stile di gara senza paura</h2><p>Cio che distingue Karlsson e la sua volonta di correre rischi.</p><h2>Specialista delle distanze</h2><p>Karlsson eccelle nelle gare di lunga distanza.</p><h2>Tradizione sciistica svedese</h2><p>La Svezia ha una fiera storia nello sci di fondo, e Karlsson continua questa tradizione.</p><h2>Rivalita con la Norvegia</h2><p>Alcune delle gare piu memorabili di Karlsson sono state contro rivali norvegesi come <a href=\"/therese-johaug-cross-country-profile/\">Therese Johaug</a>.</p><h2>Forza mentale</h2><p>Karlsson ha mostrato notevole forza mentale.</p><h2>Potenziale futuro</h2><p>Alla sua giovane eta, Karlsson ha anni di sviluppo davanti a se.</p>",
        "es": "<p>Frida Karlsson representa la proxima generacion de excelencia sueca en <a href=\"/cross-country-skiing-guide/\">esqui de fondo</a>. La joven talento ya ha logrado resultados que la colocan entre la elite mundial.</p><h2>Irrupcion en los Mundiales</h2><p>Karlsson se anuncio en la escena mundial en los Campeonatos Mundiales 2019 en Seefeld. Con solo 19 anos, capturo plata en 10km y bronce en 30km skiathlon.</p><h2>Estilo de carrera intrépido</h2><p>Lo que distingue a Karlsson es su disposicion a tomar riesgos.</p><h2>Especialista en distancia</h2><p>Karlsson destaca en eventos de larga distancia.</p><h2>Tradicion sueca del esqui</h2><p>Suecia tiene una orgullosa historia en esqui de fondo, y Karlsson continua esta tradicion.</p><h2>Rivalidad con Noruega</h2><p>Algunas de las carreras mas memorables de Karlsson han sido contra rivales noruegas como <a href=\"/therese-johaug-cross-country-profile/\">Therese Johaug</a>.</p><h2>Fortaleza mental</h2><p>Karlsson ha mostrado notable fortaleza mental.</p><h2>Potencial futuro</h2><p>A su joven edad, Karlsson tiene anos de desarrollo por delante.</p>",
        "pt": "<p>Frida Karlsson representa a proxima geracao de excelencia sueca no <a href=\"/cross-country-skiing-guide/\">esqui cross-country</a>. A jovem talento ja alcancou resultados que a colocam entre a elite mundial.</p><h2>Irrupcao nos Mundiais</h2><p>Karlsson se anunciou no cenario mundial nos Campeonatos Mundiais 2019 em Seefeld. Com apenas 19 anos, conquistou prata nos 10km e bronze no skiathlon 30km.</p><h2>Estilo de corrida destemido</h2><p>O que distingue Karlsson e sua disposicao para correr riscos.</p><h2>Especialista em distancia</h2><p>Karlsson se destaca em eventos de longa distancia.</p><h2>Tradicao sueca do esqui</h2><p>A Suecia tem uma orgulhosa historia no esqui cross-country, e Karlsson continua essa tradicao.</p><h2>Rivalidade com a Noruega</h2><p>Algumas das corridas mais memoraveis de Karlsson foram contra rivais norueguesas como <a href=\"/therese-johaug-cross-country-profile/\">Therese Johaug</a>.</p><h2>Forca mental</h2><p>Karlsson demonstrou notavel forca mental.</p><h2>Potencial futuro</h2><p>Em sua jovem idade, Karlsson tem anos de desenvolvimento pela frente.</p>",
        "nl": "<p>Frida Karlsson vertegenwoordigt de volgende generatie Zweedse <a href=\"/cross-country-skiing-guide/\">langlauf</a>-excellentie. Het jonge talent heeft al resultaten behaald die haar onder de wereldelite plaatsen.</p><h2>Doorbraak op het WK</h2><p>Karlsson kondigde zichzelf aan op het wereldtoneel op het WK 2019 in Seefeld. Op slechts 19-jarige leeftijd veroverde ze zilver op de 10km en brons op de 30km skiathlon.</p><h2>Onverschrokken racestijl</h2><p>Wat Karlsson onderscheidt is haar bereidheid om risico''s te nemen.</p><h2>Afstandsspecialist</h2><p>Karlsson blinkt uit in langeafstandsevenementen.</p><h2>Zweedse ski-traditie</h2><p>Zweden heeft een trotse geschiedenis in langlaufen, en Karlsson zet deze traditie voort.</p><h2>Rivaliteit met Noorwegen</h2><p>Sommige van Karlssons meest memorabele races waren tegen Noorse rivalen zoals <a href=\"/therese-johaug-cross-country-profile/\">Therese Johaug</a>.</p><h2>Mentale kracht</h2><p>Karlsson heeft opmerkelijke mentale kracht getoond.</p><h2>Toekomstig potentieel</h2><p>Op haar jonge leeftijd heeft Karlsson nog jaren van ontwikkeling voor zich.</p>",
        "ar": "<p>تمثل فريدا كارلسون الجيل القادم من التميز السويدي في <a href=\"/cross-country-skiing-guide/\">التزلج الريفي</a>. الموهبة الشابة حققت بالفعل نتائج تضعها بين النخبة العالمية.</p><h2>اختراق في البطولات العالمية</h2><p>أعلنت كارلسون عن نفسها على المسرح العالمي في بطولة العالم 2019 في سيفيلد. في سن 19 فقط، حصلت على الفضية في 10 كم والبرونزية في سكياثلون 30 كم.</p><h2>أسلوب سباق جريء</h2><p>ما يميز كارلسون هو استعدادها للمخاطرة.</p><h2>متخصصة في المسافات</h2><p>تتفوق كارلسون في سباقات المسافات الطويلة.</p><h2>التقليد السويدي للتزلج</h2><p>السويد لديها تاريخ فخور في التزلج الريفي، وكارلسون تواصل هذا التقليد.</p><h2>التنافس مع النرويج</h2><p>بعض أبرز سباقات كارلسون كانت ضد منافسات نرويجيات مثل <a href=\"/therese-johaug-cross-country-profile/\">تيريز يوهاوج</a>.</p><h2>القوة الذهنية</h2><p>أظهرت كارلسون قوة ذهنية ملحوظة.</p><h2>الإمكانات المستقبلية</h2><p>في سنها الصغير، لدى كارلسون سنوات من التطور أمامها.</p>",
        "ja": "<p>フリーダ・カールソンはスウェーデンの<a href=\"/cross-country-skiing-guide/\">クロスカントリースキー</a>の次世代を代表します。若い才能はすでに世界のエリートに位置する結果を達成しています。</p><h2>世界選手権での躍進</h2><p>カールソンは2019年のゼーフェルト世界選手権で世界の舞台に登場しました。わずか19歳で、10kmで銀、30kmスキアスロンで銅を獲得しました。</p><h2>恐れを知らないレーススタイル</h2><p>カールソンを際立たせているのは、リスクを取る意欲です。</p><h2>距離のスペシャリスト</h2><p>カールソンは長距離イベントで優れています。</p><h2>スウェーデンスキーの伝統</h2><p>スウェーデンにはクロスカントリースキーの誇り高い歴史があり、カールソンはこの伝統を継続しています。</p><h2>ノルウェーとのライバル関係</h2><p>カールソンの最も記憶に残るレースのいくつかは、<a href=\"/therese-johaug-cross-country-profile/\">テレーセ・ヨーハウグ</a>のようなノルウェーのライバルとのものでした。</p><h2>メンタルの強さ</h2><p>カールソンは並外れたメンタルの強さを示しました。</p><h2>将来の可能性</h2><p>若い年齢で、カールソンには成長の年月が控えています。</p>",
        "zh": "<p>Frida Karlsson daibiao Ruidian <a href=\"/cross-country-skiing-guide/\">yueye huaxue</a> de xia yidai zhuoyue. Zhe wei nianqing de rencai yijing huode le ba ta zhiyu shijie jingying zhong de chengjiu.</p><h2>Shijie jinbiaosai tupo</h2><p>Karlsson zai 2019 nian Seefeld shijie jinbiaosai shang dengchang. Jin 19 sui, ta zai 10 gongli huode yinpai, zai 30 gongli shuaxue liuxiang zhong huode tongpai.</p><h2>Wuwei de bisai fengge</h2><p>Shi Karlsson tuchu de shi ta yuanyi maoxian.</p><h2>Changtu zhuanjia</h2><p>Karlsson zai changju bisai zhong biaoxian chuzhong.</p><h2>Ruidian huaxue chuantong</h2><p>Ruidian zai yueye huaxue zhong yongyou zihao de lishi, Karlsson yanxu zhe yi chuantong.</p><h2>Yu Nuowei de jingzheng</h2><p>Karlsson zui nang wang de yixie bisai shi dui Nuowei duishou ru <a href=\"/therese-johaug-cross-country-profile/\">Therese Johaug</a>.</p><h2>Xinli suli</h2><p>Karlsson zhanshi le feifan de xinli liliang.</p><h2>Weilai qianli</h2><p>Zai ta nianqing de nianji, Karlsson hai you duo nian fazhan.</p>",
        "ko": "<p>프리다 칼손은 스웨덴 <a href=\"/cross-country-skiing-guide/\">크로스컨트리 스키</a>의 차세대를 대표합니다. 젊은 재능은 이미 세계 엘리트에 위치하는 결과를 달성했습니다.</p><h2>세계선수권 돌파</h2><p>칼손은 2019년 제펠트 세계선수권에서 세계 무대에 등장했습니다. 불과 19세에 10km에서 은메달, 30km 스키애슬론에서 동메달을 획득했습니다.</p><h2>두려움 없는 레이스 스타일</h2><p>칼손을 차별화하는 것은 위험을 감수하려는 의지입니다.</p><h2>거리 전문가</h2><p>칼손은 장거리 이벤트에서 뛰어납니다.</p><h2>스웨덴 스키 전통</h2><p>스웨덴은 크로스컨트리 스키에서 자랑스러운 역사를 가지고 있으며, 칼손은 이 전통을 이어갑니다.</p><h2>노르웨이와의 라이벌 관계</h2><p>칼손의 가장 기억에 남는 레이스 중 일부는 <a href=\"/therese-johaug-cross-country-profile/\">테레세 요하우그</a>와 같은 노르웨이 라이벌과의 것이었습니다.</p><h2>정신력</h2><p>칼손은 놀라운 정신력을 보여주었습니다.</p><h2>미래 잠재력</h2><p>젊은 나이에 칼손은 앞으로 수년간의 발전이 있습니다.</p>"
    }'::jsonb,
    'athlete-profile',
    'XC',
    '{
        "en": "Profile of Frida Karlsson, Sweden''s cross-country skiing rising star with World Championship medals and fearless racing style.",
        "de": "Profil von Frida Karlsson, Schwedens aufgehender Langlauf-Stern mit WM-Medaillen und furchtlosem Rennstil.",
        "fr": "Profil de Frida Karlsson, l''etoile montante suedoise du ski de fond avec des medailles mondiales et un style intrepide.",
        "it": "Profilo di Frida Karlsson, la stella nascente svedese dello sci di fondo con medaglie mondiali e stile coraggioso.",
        "es": "Perfil de Frida Karlsson, la estrella emergente sueca del esqui de fondo con medallas mundiales y estilo intrépido.",
        "pt": "Perfil de Frida Karlsson, a estrela em ascensao sueca do esqui cross-country com medalhas mundiais e estilo destemido.",
        "nl": "Profiel van Frida Karlsson, de rijzende Zweedse langlaufster met WK-medailles en onverschrokken racestijl.",
        "ar": "ملف فريدا كارلسون، نجمة التزلج الريفي السويدية الصاعدة بميداليات عالمية وأسلوب جريء.",
        "ja": "世界選手権メダルと恐れを知らないレーススタイルを持つスウェーデンのクロスカントリー新星、フリーダ・カールソンのプロフィール。",
        "zh": "Frida Karlsson de jianjie, yongyou shijie jinbiaosai jiangpai he wuwei bisai fengge de Ruidian yueye huaxue xinxing.",
        "ko": "세계선수권 메달과 두려움 없는 레이스 스타일을 가진 스웨덴 크로스컨트리의 떠오르는 스타 프리다 칼손의 프로필."
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
    'frida-karlsson-cross-country-profile',
    'featured',
    'Frida Karlsson skiing aggressively in cross-country race, Swedish colors, winter forest background',
    'pending'
) ON CONFLICT (article_slug, image_type) DO NOTHING;
