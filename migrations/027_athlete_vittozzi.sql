-- Migration: 027_athlete_vittozzi.sql
-- Athlete Profile: Lisa Vittozzi (Italian Biathlon)
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
    'lisa-vittozzi-biathlon-profile',
    '{
        "en": "Lisa Vittozzi: Italy''s Biathlon Rising Star",
        "de": "Lisa Vittozzi: Italiens aufgehender Biathlon-Stern",
        "fr": "Lisa Vittozzi: L''etoile montante du biathlon italien",
        "it": "Lisa Vittozzi: La stella nascente del biathlon italiano",
        "es": "Lisa Vittozzi: La estrella emergente del biatlon italiano",
        "pt": "Lisa Vittozzi: A estrela em ascensao do biatlon italiano",
        "nl": "Lisa Vittozzi: De rijzende ster van het Italiaanse biatlon",
        "ar": "ليزا فيتوزي: نجمة البياثلون الإيطالية الصاعدة",
        "ja": "リサ・ヴィットッツィ：イタリアバイアスロンの新星",
        "zh": "Lisa Vittozzi: Yidali dongji liangxiang xinxing",
        "ko": "리사 비토치: 이탈리아 바이애슬론의 떠오르는 스타"
    }'::jsonb,
    '{
        "en": "The Italian biathlete who has emerged as a World Cup contender with exceptional shooting accuracy and competitive skiing speed.",
        "de": "Die italienische Biathletin, die sich mit aussergewoehnlicher Schiessgenauigkeit und wettbewerbsfaehiger Skigeschwindigkeit als Weltcup-Anwaerterin etabliert hat.",
        "fr": "La biathlonienne italienne qui s''est imposee comme une pretendante a la Coupe du monde avec une precision de tir exceptionnelle.",
        "it": "La biatleta italiana che si e affermata come contendente alla Coppa del Mondo con precisione di tiro eccezionale.",
        "es": "La biatleta italiana que ha emergido como contendiente de la Copa del Mundo con precision de tiro excepcional.",
        "pt": "A biatleta italiana que emergiu como candidata a Copa do Mundo com precisao de tiro excepcional.",
        "nl": "De Italiaanse biatlete die is opgekomen als Wereldbeker-kanshebber met uitzonderlijke schietnauwkeurigheid.",
        "ar": "لاعبة البياثلون الإيطالية التي برزت كمنافسة على كأس العالم بدقة تصويب استثنائية",
        "ja": "卓越した射撃精度でワールドカップ争いに浮上したイタリアのバイアスロン選手",
        "zh": "Yi chuzhong de sheji jingdu chengwei shijie bei jingzhengzhe de Yidali dongji liangxiang xuanshou",
        "ko": "뛰어난 사격 정확도로 월드컵 경쟁자로 부상한 이탈리아 바이애슬론 선수"
    }'::jsonb,
    '{
        "en": "<p>Lisa Vittozzi has established herself as one of the top athletes in <a href=\"/biathlon-guide/\">biathlon</a>. The Italian competitor combines excellent shooting with improving skiing speed to challenge for World Cup victories and overall standings.</p><h2>Italian Biathlon Tradition</h2><p>Italy has a proud biathlon history, and Vittozzi continues this tradition. Alongside teammate <a href=\"/dorothea-wierer-biathlon-profile/\">Dorothea Wierer</a>, she represents the strength of Italian women''s biathlon. The two have pushed each other to greater heights while giving Italian fans athletes to cheer for on the World Cup circuit.</p><h2>Shooting Excellence</h2><p>Vittozzi''s greatest strength is her shooting. She consistently hits targets in both prone and standing positions, which is crucial in biathlon. Clean shooting stages can make the difference between winning and finishing in the middle of the pack. Her calm approach under pressure helps her deliver when it matters most.</p><h2>Skiing Development</h2><p>While shooting has always been strong, Vittozzi has worked hard to improve her skiing speed. The cross-country skiing portion of biathlon requires excellent endurance and technique. Each season, she has narrowed the gap to the fastest skiers, making her a more complete competitor.</p><h2>World Cup Success</h2><p>Vittozzi has claimed multiple World Cup podiums and victories. Her breakthrough seasons showed she could compete with the best in the world. The overall World Cup standings require consistency across all race formats, from sprints to mass starts, and Vittozzi has proven capable in all of them.</p><h2>Major Championships</h2><p>World Championship performances have added medals to her collection. Competing against athletes like <a href=\"/johannes-thingnes-boe-biathlon-profile/\">Johannes Thingnes Boe</a>''s female counterparts, she has shown she belongs among the elite. Her best results often come in the individual format where her shooting shines.</p><h2>Future Outlook</h2><p>With continued improvement in skiing speed and maintained shooting excellence, Vittozzi is positioned for more success. Italian biathlon fans can look forward to watching her compete at the highest level for years to come.</p>",
        "de": "<p>Lisa Vittozzi hat sich als eine der Top-Athletinnen im <a href=\"/biathlon-guide/\">Biathlon</a> etabliert. Die italienische Wettkampflerin kombiniert exzellentes Schiessen mit verbesserter Skigeschwindigkeit.</p><h2>Italienische Biathlon-Tradition</h2><p>Italien hat eine stolze Biathlon-Geschichte, und Vittozzi setzt diese Tradition fort. Zusammen mit Teamkollegin <a href=\"/dorothea-wierer-biathlon-profile/\">Dorothea Wierer</a> repraesentiert sie die Staerke des italienischen Damen-Biathlons.</p><h2>Schiess-Exzellenz</h2><p>Vittozzis groesste Staerke ist ihr Schiessen. Sie trifft konstant Ziele in Liegend- und Stehendpositionen.</p><h2>Ski-Entwicklung</h2><p>Waehrend das Schiessen immer stark war, hat Vittozzi hart an ihrer Skigeschwindigkeit gearbeitet.</p><h2>Weltcup-Erfolg</h2><p>Vittozzi hat mehrere Weltcup-Podien und Siege erreicht.</p><h2>Grosse Meisterschaften</h2><p>WM-Leistungen haben Medaillen zu ihrer Sammlung hinzugefuegt.</p><h2>Zukunftsaussichten</h2><p>Mit weiterer Verbesserung ist Vittozzi fuer mehr Erfolg positioniert.</p>",
        "fr": "<p>Lisa Vittozzi s''est imposee comme l''une des meilleures athletes du <a href=\"/biathlon-guide/\">biathlon</a>. La competitrice italienne combine un excellent tir avec une vitesse de ski en amelioration.</p><h2>Tradition italienne du biathlon</h2><p>L''Italie a une fiere histoire du biathlon, et Vittozzi poursuit cette tradition. Aux cotes de sa coequipiere <a href=\"/dorothea-wierer-biathlon-profile/\">Dorothea Wierer</a>, elle represente la force du biathlon feminin italien.</p><h2>Excellence au tir</h2><p>La plus grande force de Vittozzi est son tir. Elle touche regulierement les cibles en positions couchee et debout.</p><h2>Developpement en ski</h2><p>Alors que le tir a toujours ete fort, Vittozzi a travaille dur pour ameliorer sa vitesse de ski.</p><h2>Succes en Coupe du monde</h2><p>Vittozzi a remporte plusieurs podiums et victoires en Coupe du monde.</p><h2>Grands championnats</h2><p>Ses performances aux Championnats du monde ont ajoute des medailles a sa collection.</p><h2>Perspectives</h2><p>Avec une amelioration continue, Vittozzi est positionnee pour plus de succes.</p>",
        "it": "<p>Lisa Vittozzi si e affermata come una delle migliori atlete del <a href=\"/biathlon-guide/\">biathlon</a>. La competitrice italiana combina un tiro eccellente con una velocita sugli sci in miglioramento.</p><h2>Tradizione italiana del biathlon</h2><p>L''Italia ha una fiera storia nel biathlon, e Vittozzi continua questa tradizione. Insieme alla compagna di squadra <a href=\"/dorothea-wierer-biathlon-profile/\">Dorothea Wierer</a>, rappresenta la forza del biathlon femminile italiano.</p><h2>Eccellenza nel tiro</h2><p>La piu grande forza di Vittozzi e il suo tiro. Colpisce costantemente i bersagli nelle posizioni a terra e in piedi.</p><h2>Sviluppo nello sci</h2><p>Mentre il tiro e sempre stato forte, Vittozzi ha lavorato duramente per migliorare la sua velocita sugli sci.</p><h2>Successo in Coppa del Mondo</h2><p>Vittozzi ha conquistato diversi podi e vittorie in Coppa del Mondo.</p><h2>Grandi campionati</h2><p>Le prestazioni ai Mondiali hanno aggiunto medaglie alla sua collezione.</p><h2>Prospettive</h2><p>Con un continuo miglioramento, Vittozzi e posizionata per ulteriori successi.</p>",
        "es": "<p>Lisa Vittozzi se ha establecido como una de las mejores atletas del <a href=\"/biathlon-guide/\">biatlon</a>. La competidora italiana combina excelente tiro con velocidad de esqui en mejora.</p><h2>Tradicion italiana del biatlon</h2><p>Italia tiene una orgullosa historia en biatlon, y Vittozzi continua esta tradicion. Junto a su companera <a href=\"/dorothea-wierer-biathlon-profile/\">Dorothea Wierer</a>, representa la fortaleza del biatlon femenino italiano.</p><h2>Excelencia en el tiro</h2><p>La mayor fortaleza de Vittozzi es su tiro.</p><h2>Desarrollo en esqui</h2><p>Mientras el tiro siempre ha sido fuerte, Vittozzi ha trabajado duro para mejorar su velocidad de esqui.</p><h2>Exito en Copa del Mundo</h2><p>Vittozzi ha logrado multiples podios y victorias en Copa del Mundo.</p><h2>Grandes campeonatos</h2><p>Sus actuaciones en Campeonatos Mundiales han anadido medallas a su coleccion.</p><h2>Perspectivas</h2><p>Con mejora continua, Vittozzi esta posicionada para mas exito.</p>",
        "pt": "<p>Lisa Vittozzi se estabeleceu como uma das melhores atletas do <a href=\"/biathlon-guide/\">biatlo</a>. A competidora italiana combina excelente tiro com velocidade de esqui em melhoria.</p><h2>Tradicao italiana do biatlo</h2><p>A Italia tem uma orgulhosa historia no biatlo, e Vittozzi continua essa tradicao. Ao lado da companheira <a href=\"/dorothea-wierer-biathlon-profile/\">Dorothea Wierer</a>, ela representa a forca do biatlo feminino italiano.</p><h2>Excelencia no tiro</h2><p>A maior forca de Vittozzi e seu tiro.</p><h2>Desenvolvimento no esqui</h2><p>Enquanto o tiro sempre foi forte, Vittozzi trabalhou duro para melhorar sua velocidade de esqui.</p><h2>Sucesso na Copa do Mundo</h2><p>Vittozzi conquistou multiplos podios e vitorias na Copa do Mundo.</p><h2>Grandes campeonatos</h2><p>Suas atuacoes em Campeonatos Mundiais adicionaram medalhas a sua colecao.</p><h2>Perspectivas</h2><p>Com melhoria continua, Vittozzi esta posicionada para mais sucesso.</p>",
        "nl": "<p>Lisa Vittozzi heeft zichzelf gevestigd als een van de topathleten in <a href=\"/biathlon-guide/\">biatlon</a>. De Italiaanse wedstrijdster combineert uitstekend schieten met verbeterende skisnelheid.</p><h2>Italiaanse biatlon-traditie</h2><p>Italie heeft een trotse biatlon-geschiedenis, en Vittozzi zet deze traditie voort. Samen met teamgenote <a href=\"/dorothea-wierer-biathlon-profile/\">Dorothea Wierer</a> vertegenwoordigt ze de kracht van het Italiaanse vrouwenbiatlon.</p><h2>Schietexcellentie</h2><p>Vittozzi''s grootste kracht is haar schieten.</p><h2>Ski-ontwikkeling</h2><p>Terwijl het schieten altijd sterk was, heeft Vittozzi hard gewerkt aan haar skisnelheid.</p><h2>Wereldbeker-succes</h2><p>Vittozzi heeft meerdere Wereldbeker-podiums en overwinningen behaald.</p><h2>Grote kampioenschappen</h2><p>Haar WK-prestaties hebben medailles toegevoegd aan haar collectie.</p><h2>Vooruitzichten</h2><p>Met voortdurende verbetering is Vittozzi gepositioneerd voor meer succes.</p>",
        "ar": "<p>أثبتت ليزا فيتوزي نفسها كواحدة من أفضل الرياضيين في <a href=\"/biathlon-guide/\">البياثلون</a>. تجمع المنافسة الإيطالية بين التصويب الممتاز وسرعة التزلج المتحسنة.</p><h2>تقليد البياثلون الإيطالي</h2><p>لإيطاليا تاريخ فخور في البياثلون، وفيتوزي تواصل هذا التقليد. إلى جانب زميلتها <a href=\"/dorothea-wierer-biathlon-profile/\">دوروثيا فيرير</a>، تمثل قوة البياثلون النسائي الإيطالي.</p><h2>التميز في الرماية</h2><p>أكبر نقطة قوة لفيتوزي هي رمايتها.</p><h2>تطوير التزلج</h2><p>بينما كانت الرماية قوية دائماً، عملت فيتوزي بجد لتحسين سرعة تزلجها.</p><h2>نجاح كأس العالم</h2><p>حققت فيتوزي عدة منصات تتويج وانتصارات في كأس العالم.</p><h2>البطولات الكبرى</h2><p>أضافت أداؤها في بطولات العالم ميداليات إلى مجموعتها.</p><h2>التوقعات</h2><p>مع التحسن المستمر، فيتوزي في وضع يؤهلها لمزيد من النجاح.</p>",
        "ja": "<p>リサ・ヴィットッツィは<a href=\"/biathlon-guide/\">バイアスロン</a>のトップ選手の一人として確立しました。このイタリアの競技者は、優れた射撃と向上するスキー速度を組み合わせています。</p><h2>イタリアバイアスロンの伝統</h2><p>イタリアには誇り高いバイアスロンの歴史があり、ヴィットッツィはこの伝統を継続しています。チームメイトの<a href=\"/dorothea-wierer-biathlon-profile/\">ドロテア・ヴィーラー</a>と共に、イタリア女子バイアスロンの強さを代表しています。</p><h2>射撃の卓越性</h2><p>ヴィットッツィの最大の強みは射撃です。</p><h2>スキーの発展</h2><p>射撃は常に強かったですが、ヴィットッツィはスキー速度の向上に懸命に取り組んできました。</p><h2>ワールドカップでの成功</h2><p>ヴィットッツィは複数のワールドカップ表彰台と勝利を獲得しています。</p><h2>主要選手権</h2><p>世界選手権でのパフォーマンスがメダルを追加しました。</p><h2>展望</h2><p>継続的な向上により、ヴィットッツィはさらなる成功に向けてポジショニングされています。</p>",
        "zh": "<p>Lisa Vittozzi yi queli wei <a href=\"/biathlon-guide/\">dongji liangxiang</a> de dingji yundongyuan zhiyi. Zhe wei Yidali jingzhengzhe jiangli youxiu de sheji yu tigao de huaxue sudu xiangjiehe.</p><h2>Yidali dongji liangxiang chuantong</h2><p>Yidali yongyou zihao de dongji liangxiang lishi, Vittozzi yanxu zhe yi chuantong. Yu duiyou <a href=\"/dorothea-wierer-biathlon-profile/\">Dorothea Wierer</a> yiqi, ta daibiao Yidali nvzi dongji liangxiang de shili.</p><h2>Sheji zhuoyue</h2><p>Vittozzi zui da de youshi shi ta de sheji.</p><h2>Huaxue fazhan</h2><p>Suiran sheji yizhi hen qiang, dan Vittozzi nuli tigao huaxue sudu.</p><h2>Shijie bei chenggong</h2><p>Vittozzi yingle duoge shijie bei lingjiangtai he shengli.</p><h2>Da jinbiaosai</h2><p>Shijie jinbiaosai de biaoxian zengjia le jiangpai.</p><h2>Zhanwang</h2><p>Suizhe chixu jinbu, Vittozzi you wanghuode gengduo chenggong.</p>",
        "ko": "<p>리사 비토치는 <a href=\"/biathlon-guide/\">바이애슬론</a>에서 최고의 선수 중 하나로 자리매김했습니다. 이 이탈리아 경쟁자는 뛰어난 사격과 향상되는 스키 속도를 결합합니다.</p><h2>이탈리아 바이애슬론 전통</h2><p>이탈리아는 자랑스러운 바이애슬론 역사를 가지고 있으며, 비토치는 이 전통을 이어갑니다. 팀 동료 <a href=\"/dorothea-wierer-biathlon-profile/\">도로테아 비러</a>와 함께 이탈리아 여자 바이애슬론의 강점을 대표합니다.</p><h2>사격 우수성</h2><p>비토치의 가장 큰 강점은 사격입니다.</p><h2>스키 발전</h2><p>사격은 항상 강했지만, 비토치는 스키 속도 향상을 위해 열심히 노력해왔습니다.</p><h2>월드컵 성공</h2><p>비토치는 여러 월드컵 포디움과 승리를 달성했습니다.</p><h2>주요 선수권</h2><p>세계선수권 성적이 메달을 추가했습니다.</p><h2>전망</h2><p>지속적인 향상으로 비토치는 더 많은 성공을 위한 위치에 있습니다.</p>"
    }'::jsonb,
    'athlete-profile',
    'BT',
    '{
        "en": "Profile of Lisa Vittozzi, the Italian biathlon rising star with exceptional shooting accuracy competing for World Cup victories.",
        "de": "Profil von Lisa Vittozzi, dem aufsteigenden italienischen Biathlon-Stern mit aussergewoehnlicher Schiessgenauigkeit.",
        "fr": "Profil de Lisa Vittozzi, l''etoile montante italienne du biathlon avec une precision de tir exceptionnelle.",
        "it": "Profilo di Lisa Vittozzi, la stella nascente del biathlon italiano con precisione di tiro eccezionale.",
        "es": "Perfil de Lisa Vittozzi, la estrella emergente del biatlon italiano con precision de tiro excepcional.",
        "pt": "Perfil de Lisa Vittozzi, a estrela em ascensao do biatlo italiano com precisao de tiro excepcional.",
        "nl": "Profiel van Lisa Vittozzi, de rijzende ster van het Italiaanse biatlon met uitzonderlijke schietnauwkeurigheid.",
        "ar": "ملف ليزا فيتوزي، نجمة البياثلون الإيطالية الصاعدة بدقة تصويب استثنائية.",
        "ja": "卓越した射撃精度を持つイタリアバイアスロンの新星、リサ・ヴィットッツィのプロフィール。",
        "zh": "Lisa Vittozzi de jianjie, yi chuzhong sheji jingdu jingzheng shijie bei shengli de Yidali dongji liangxiang xinxing.",
        "ko": "뛰어난 사격 정확도로 월드컵 승리를 경쟁하는 이탈리아 바이애슬론의 떠오르는 스타 리사 비토치의 프로필."
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
    'lisa-vittozzi-biathlon-profile',
    'featured',
    'Lisa Vittozzi at shooting range in biathlon competition, Italian team colors, focused aim',
    'pending'
) ON CONFLICT (article_slug, image_type) DO NOTHING;
