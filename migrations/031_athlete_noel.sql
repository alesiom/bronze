-- Migration: 031_athlete_noel.sql
-- Athlete Profile: Clement Noel (French Alpine Skiing - Slalom)
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
    'clement-noel-alpine-skiing-profile',
    '{
        "en": "Clement Noel: France''s Slalom Specialist",
        "de": "Clement Noel: Frankreichs Slalom-Spezialist",
        "fr": "Clement Noel: Le specialiste francais du slalom",
        "it": "Clement Noel: Lo specialista francese dello slalom",
        "es": "Clement Noel: El especialista frances del eslalon",
        "pt": "Clement Noel: O especialista frances do slalom",
        "nl": "Clement Noel: De Franse slalom specialist",
        "ar": "كليمون نويل: متخصص التعرج الفرنسي",
        "ja": "クレマン・ノエル：フランスのスラロームスペシャリスト",
        "zh": "Clement Noel: Faguo huixuan zhuanjia",
        "ko": "클레망 노엘: 프랑스의 슬랄롬 스페셜리스트"
    }'::jsonb,
    '{
        "en": "The French slalom skier who combines explosive speed with technical precision to challenge for victories at the sport''s most famous venues.",
        "de": "Der franzoesische Slalom-Skifahrer, der explosive Geschwindigkeit mit technischer Praezision kombiniert.",
        "fr": "Le slalomeur francais qui combine vitesse explosive et precision technique pour viser les victoires.",
        "it": "Lo slalomista francese che combina velocita esplosiva con precisione tecnica.",
        "es": "El esquiador de eslalon frances que combina velocidad explosiva con precision tecnica.",
        "pt": "O esquiador de slalom frances que combina velocidade explosiva com precisao tecnica.",
        "nl": "De Franse slalomskier die explosieve snelheid combineert met technische precisie.",
        "ar": "متزلج التعرج الفرنسي الذي يجمع بين السرعة المتفجرة والدقة التقنية",
        "ja": "爆発的なスピードと技術的な精度を組み合わせたフランスのスラロームスキー選手",
        "zh": "Jiangli baofaxing sudu yu jishu jingzhun de Faguo huixuan huaxue xuanshou",
        "ko": "폭발적인 스피드와 기술적 정밀함을 결합한 프랑스 슬랄롬 스키 선수"
    }'::jsonb,
    '{
        "en": "<p>Clement Noel has established himself as one of the top slalom skiers in <a href=\"/alpine-skiing-guide/\">alpine skiing</a>. The Frenchman''s aggressive style and technical excellence have produced memorable victories on the World Cup circuit.</p><h2>Quick Rise to the Top</h2><p>Noel burst onto the scene with World Cup victories early in his career. His ability to attack courses with precision while maintaining high speeds made him an instant threat in slalom. French ski racing gained a new star capable of challenging the established order.</p><h2>Historic Venues</h2><p>Some of Noel''s best performances have come at slalom''s most storied venues. Victory at Wengen and strong results at Kitzbuehel demonstrate his ability to perform under pressure at legendary locations. These races attract massive crowds and media attention, and Noel has proven he can deliver when the spotlight is brightest.</p><h2>Technical Excellence</h2><p>Slalom requires perfect edge control and the ability to make quick adjustments. Noel excels at reading courses and choosing optimal lines through the gates. His skiing appears smooth even at high speeds, a sign of exceptional technical ability. Each turn flows into the next with precision.</p><h2>French Skiing Pride</h2><p>France has a proud alpine skiing tradition, and Noel helps continue this legacy. He races alongside talented teammates and carries the hopes of French fans who fill mountain venues. The pressure of representing such a skiing nation has not affected his performances.</p><h2>Rivalry with the Best</h2><p>Noel regularly battles against top slalom competitors including <a href=\"/henrik-kristoffersen-alpine-skiing-profile/\">Henrik Kristoffersen</a> and others vying for World Cup victories. These close races push all athletes to their limits. The depth of talent in modern slalom means every race is competitive.</p><h2>Consistent Performer</h2><p>What separates Noel from many competitors is his consistency. He rarely has poor results, instead delivering solid performances race after race. This reliability earns valuable World Cup points and keeps him in contention for titles throughout each season.</p><h2>Future Goals</h2><p>Noel continues to pursue World Championship and overall slalom World Cup titles. With his technical skills and competitive fire, he remains among the favorites whenever he starts. French fans expect more memorable victories in the seasons ahead.</p>",
        "de": "<p>Clement Noel hat sich als einer der Top-Slalomfahrer im <a href=\"/alpine-skiing-guide/\">alpinen Skisport</a> etabliert. Der aggressive Stil und die technische Exzellenz des Franzosen haben denkwuerdige Siege im Weltcup produziert.</p><h2>Schneller Aufstieg an die Spitze</h2><p>Noel stuermte frueh in seiner Karriere mit Weltcup-Siegen auf die Buehne.</p><h2>Historische Austragungsorte</h2><p>Einige von Noels besten Leistungen kamen an den legendaersten Slalom-Orten wie Wengen und Kitzbuehel.</p><h2>Technische Exzellenz</h2><p>Slalom erfordert perfekte Kantenkontrolle und die Faehigkeit, schnelle Anpassungen vorzunehmen.</p><h2>Franzoesischer Skistolz</h2><p>Frankreich hat eine stolze alpine Skitradition, und Noel hilft, dieses Vermaechtnis fortzusetzen.</p><h2>Rivalitaet mit den Besten</h2><p>Noel kaempft regelmaessig gegen Top-Slalomkonkurrenten wie <a href=\"/henrik-kristoffersen-alpine-skiing-profile/\">Henrik Kristoffersen</a>.</p><h2>Konstanter Performer</h2><p>Was Noel von vielen Konkurrenten unterscheidet, ist seine Konstanz.</p><h2>Zukuenftige Ziele</h2><p>Noel verfolgt weiterhin WM- und Slalom-Gesamtweltcup-Titel.</p>",
        "fr": "<p>Clement Noel s''est impose comme l''un des meilleurs slalomeurs du <a href=\"/alpine-skiing-guide/\">ski alpin</a>. Le style agressif et l''excellence technique du Francais ont produit des victoires memorables sur le circuit de la Coupe du monde.</p><h2>Ascension rapide au sommet</h2><p>Noel a fait irruption sur la scene avec des victoires en Coupe du monde tot dans sa carriere.</p><h2>Sites historiques</h2><p>Certaines des meilleures performances de Noel sont venues sur les sites les plus legendaires du slalom comme Wengen et Kitzbuehel.</p><h2>Excellence technique</h2><p>Le slalom exige un controle parfait des carres et la capacite de faire des ajustements rapides.</p><h2>Fierte du ski francais</h2><p>La France a une fiere tradition du ski alpin, et Noel aide a perpetuer cet heritage.</p><h2>Rivalite avec les meilleurs</h2><p>Noel affronte regulierement les meilleurs slalomeurs dont <a href=\"/henrik-kristoffersen-alpine-skiing-profile/\">Henrik Kristoffersen</a>.</p><h2>Performeur constant</h2><p>Ce qui separe Noel de nombreux concurrents est sa regularite.</p><h2>Objectifs futurs</h2><p>Noel continue de poursuivre les titres de Championnats du monde et de Coupe du monde de slalom.</p>",
        "it": "<p>Clement Noel si e affermato come uno dei migliori slalomisti dello <a href=\"/alpine-skiing-guide/\">sci alpino</a>. Lo stile aggressivo e l''eccellenza tecnica del francese hanno prodotto vittorie memorabili nel circuito di Coppa del Mondo.</p><h2>Rapida ascesa alla vetta</h2><p>Noel ha fatto irruzione sulla scena con vittorie in Coppa del Mondo all''inizio della sua carriera.</p><h2>Luoghi storici</h2><p>Alcune delle migliori prestazioni di Noel sono arrivate nei luoghi piu leggendari dello slalom come Wengen e Kitzbuehel.</p><h2>Eccellenza tecnica</h2><p>Lo slalom richiede un perfetto controllo delle lamine e la capacita di fare aggiustamenti rapidi.</p><h2>Orgoglio dello sci francese</h2><p>La Francia ha una fiera tradizione dello sci alpino, e Noel aiuta a continuare questa eredita.</p><h2>Rivalita con i migliori</h2><p>Noel affronta regolarmente i migliori slalomisti tra cui <a href=\"/henrik-kristoffersen-alpine-skiing-profile/\">Henrik Kristoffersen</a>.</p><h2>Performer costante</h2><p>Cio che separa Noel da molti concorrenti e la sua costanza.</p><h2>Obiettivi futuri</h2><p>Noel continua a perseguire i titoli dei Campionati Mondiali e della Coppa del Mondo di slalom.</p>",
        "es": "<p>Clement Noel se ha establecido como uno de los mejores slalomistas del <a href=\"/alpine-skiing-guide/\">esqui alpino</a>. El estilo agresivo y la excelencia tecnica del frances han producido victorias memorables en el circuito de la Copa del Mundo.</p><h2>Rapido ascenso a la cima</h2><p>Noel irrumpio en la escena con victorias de Copa del Mundo temprano en su carrera.</p><h2>Sedes historicas</h2><p>Algunas de las mejores actuaciones de Noel han sido en las sedes mas legendarias del eslalon como Wengen y Kitzbuehel.</p><h2>Excelencia tecnica</h2><p>El eslalon requiere perfecto control de cantos y la capacidad de hacer ajustes rapidos.</p><h2>Orgullo del esqui frances</h2><p>Francia tiene una orgullosa tradicion del esqui alpino, y Noel ayuda a continuar este legado.</p><h2>Rivalidad con los mejores</h2><p>Noel batalla regularmente contra los mejores slalomistas incluyendo <a href=\"/henrik-kristoffersen-alpine-skiing-profile/\">Henrik Kristoffersen</a>.</p><h2>Rendimiento constante</h2><p>Lo que separa a Noel de muchos competidores es su consistencia.</p><h2>Metas futuras</h2><p>Noel continua persiguiendo titulos de Campeonato Mundial y Copa del Mundo de eslalon.</p>",
        "pt": "<p>Clement Noel se estabeleceu como um dos melhores slalomistas do <a href=\"/alpine-skiing-guide/\">esqui alpino</a>. O estilo agressivo e a excelencia tecnica do frances produziram vitorias memoraveis no circuito da Copa do Mundo.</p><h2>Rapida ascensao ao topo</h2><p>Noel explodiu na cena com vitorias na Copa do Mundo no inicio de sua carreira.</p><h2>Locais historicos</h2><p>Algumas das melhores atuacoes de Noel vieram nos locais mais lendarios do slalom como Wengen e Kitzbuehel.</p><h2>Excelencia tecnica</h2><p>O slalom requer controle perfeito das bordas e capacidade de fazer ajustes rapidos.</p><h2>Orgulho do esqui frances</h2><p>A Franca tem uma orgulhosa tradicao do esqui alpino, e Noel ajuda a continuar esse legado.</p><h2>Rivalidade com os melhores</h2><p>Noel batalha regularmente contra os melhores slalomistas incluindo <a href=\"/henrik-kristoffersen-alpine-skiing-profile/\">Henrik Kristoffersen</a>.</p><h2>Desempenho consistente</h2><p>O que separa Noel de muitos concorrentes e sua consistencia.</p><h2>Metas futuras</h2><p>Noel continua perseguindo titulos de Campeonato Mundial e Copa do Mundo de slalom.</p>",
        "nl": "<p>Clement Noel heeft zichzelf gevestigd als een van de beste slalomskiers in <a href=\"/alpine-skiing-guide/\">alpineskien</a>. De agressieve stijl en technische excellentie van de Fransman hebben memorabele overwinningen op het Wereldbeker-circuit opgeleverd.</p><h2>Snelle opkomst naar de top</h2><p>Noel brak vroeg in zijn carriere door met Wereldbeker-overwinningen.</p><h2>Historische locaties</h2><p>Sommige van Noels beste prestaties kwamen op de meest legendarische slalomlocaties zoals Wengen en Kitzbuehel.</p><h2>Technische excellentie</h2><p>Slalom vereist perfecte kantencontrole en het vermogen om snelle aanpassingen te maken.</p><h2>Franse ski-trots</h2><p>Frankrijk heeft een trotse alpineski-traditie, en Noel helpt deze erfenis voort te zetten.</p><h2>Rivaliteit met de besten</h2><p>Noel strijdt regelmatig tegen topslalomcompetitoren waaronder <a href=\"/henrik-kristoffersen-alpine-skiing-profile/\">Henrik Kristoffersen</a>.</p><h2>Consistente performer</h2><p>Wat Noel onderscheidt van veel concurrenten is zijn consistentie.</p><h2>Toekomstige doelen</h2><p>Noel blijft WK- en slalom Wereldbeker-titels najagen.</p>",
        "ar": "<p>أثبت كليمون نويل نفسه كواحد من أفضل متزلجي التعرج في <a href=\"/alpine-skiing-guide/\">التزلج الألبي</a>. أنتج الأسلوب العدواني والتميز التقني للفرنسي انتصارات لا تُنسى في دائرة كأس العالم.</p><h2>صعود سريع للقمة</h2><p>اقتحم نويل المشهد بانتصارات كأس العالم في وقت مبكر من مسيرته.</p><h2>مواقع تاريخية</h2><p>جاءت بعض أفضل أداءات نويل في أسطورية مواقع التعرج مثل وينغن وكيتزبويل.</p><h2>التميز التقني</h2><p>يتطلب التعرج تحكماً مثالياً بالحواف والقدرة على إجراء تعديلات سريعة.</p><h2>فخر التزلج الفرنسي</h2><p>لفرنسا تقليد فخور في التزلج الألبي، ونويل يساعد في استمرار هذا الإرث.</p><h2>التنافس مع الأفضل</h2><p>يتنافس نويل بانتظام ضد أفضل متزلجي التعرج بما في ذلك <a href=\"/henrik-kristoffersen-alpine-skiing-profile/\">هنريك كريستوفرسن</a>.</p><h2>أداء مستمر</h2><p>ما يميز نويل عن كثير من المنافسين هو استمراريته.</p><h2>الأهداف المستقبلية</h2><p>يواصل نويل السعي لألقاب بطولة العالم وكأس العالم للتعرج.</p>",
        "ja": "<p>クレマン・ノエルは<a href=\"/alpine-skiing-guide/\">アルペンスキー</a>のトップスラローム選手の一人として確立しました。フランス人のアグレッシブなスタイルと技術的な卓越性は、ワールドカップサーキットで記憶に残る勝利を生み出しました。</p><h2>トップへの急速な上昇</h2><p>ノエルはキャリア初期にワールドカップ勝利でシーンに登場しました。</p><h2>歴史的な会場</h2><p>ノエルの最高のパフォーマンスのいくつかは、ウェンゲンやキッツビュールなど最も伝説的なスラローム会場で生まれました。</p><h2>技術的卓越性</h2><p>スラロームは完璧なエッジコントロールと素早い調整能力を必要とします。</p><h2>フランススキーの誇り</h2><p>フランスには誇り高いアルペンスキーの伝統があり、ノエルはこの遺産を継続するのに役立っています。</p><h2>最高との競争</h2><p>ノエルは定期的に<a href=\"/henrik-kristoffersen-alpine-skiing-profile/\">ヘンリク・クリストッフェルセン</a>を含むトップスラローム競技者と戦います。</p><h2>安定したパフォーマー</h2><p>ノエルを多くの競技者から分けるのは一貫性です。</p><h2>将来の目標</h2><p>ノエルは世界選手権とスラロームワールドカップのタイトルを追求し続けています。</p>",
        "zh": "<p>Clement Noel yi queli wei <a href=\"/alpine-skiing-guide/\">gaoshan huaxue</a> de dingji huixuan xuanshou zhiyi. Faguo ren de jinggong fengge he jishu zhuoyue zai shijie bei saiquan zhong chansheng le nanwang de shengli.</p><h2>Kuaisu shangsheng dao dingfeng</h2><p>Noel zai zhiye shengya zaoqi yi shijie bei shengli dengchang.</p><h2>Lishi xing changdi</h2><p>Noel de yixie zuijia biaoxian laizi zuiju chuanqi de huixuan changdi ru Wengen he Kitzbuehel.</p><h2>Jishu zhuoyue</h2><p>Huixuan xuyao wanmei de bianyuan kongzhi he kuaisu tiaozheng nengli.</p><h2>Faguo huaxue zihao</h2><p>Faguo yongyou zihao de gaoshan huaxue chuantong, Noel bangzhu yanxu zhe yi yichan.</p><h2>Yu zuihao de jingzheng</h2><p>Noel jingchang yu dingji huixuan jingzhengzhe baokuo <a href=\"/henrik-kristoffersen-alpine-skiing-profile/\">Henrik Kristoffersen</a> duikang.</p><h2>Wending de biaoxianzhe</h2><p>Shi Noel yu xuduo jingzhengzhe butong de shi ta de yiguanxing.</p><h2>Weilai mubiao</h2><p>Noel jixu zhuiqiu shijie jinbiaosai he huixuan shijie bei guanjun.</p>",
        "ko": "<p>클레망 노엘은 <a href=\"/alpine-skiing-guide/\">알파인 스키</a>의 최고 슬랄롬 스키어 중 하나로 자리매김했습니다. 프랑스인의 공격적인 스타일과 기술적 우수성은 월드컵 서킷에서 기억에 남는 승리를 만들어냈습니다.</p><h2>정상으로의 빠른 상승</h2><p>노엘은 커리어 초기에 월드컵 승리로 등장했습니다.</p><h2>역사적인 장소</h2><p>노엘의 최고 성적 중 일부는 벤겐과 키츠뷔엘 같은 가장 전설적인 슬랄롬 장소에서 나왔습니다.</p><h2>기술적 우수성</h2><p>슬랄롬은 완벽한 에지 컨트롤과 빠른 조정 능력을 요구합니다.</p><h2>프랑스 스키의 자부심</h2><p>프랑스는 자랑스러운 알파인 스키 전통을 가지고 있으며, 노엘은 이 유산을 이어가는 데 도움을 줍니다.</p><h2>최고와의 경쟁</h2><p>노엘은 정기적으로 <a href=\"/henrik-kristoffersen-alpine-skiing-profile/\">헨리크 크리스토퍼센</a>을 포함한 최고의 슬랄롬 경쟁자들과 싸웁니다.</p><h2>일관된 선수</h2><p>노엘을 많은 경쟁자와 구별하는 것은 일관성입니다.</p><h2>미래 목표</h2><p>노엘은 세계선수권과 슬랄롬 월드컵 타이틀을 계속 추구합니다.</p>"
    }'::jsonb,
    'athlete-profile',
    'AS',
    '{
        "en": "Profile of Clement Noel, France''s slalom specialist with explosive speed and technical precision at the sport''s most famous venues.",
        "de": "Profil von Clement Noel, Frankreichs Slalom-Spezialist mit explosiver Geschwindigkeit und technischer Praezision.",
        "fr": "Profil de Clement Noel, le specialiste francais du slalom avec vitesse explosive et precision technique.",
        "it": "Profilo di Clement Noel, lo specialista francese dello slalom con velocita esplosiva e precisione tecnica.",
        "es": "Perfil de Clement Noel, el especialista frances del eslalon con velocidad explosiva y precision tecnica.",
        "pt": "Perfil de Clement Noel, o especialista frances do slalom com velocidade explosiva e precisao tecnica.",
        "nl": "Profiel van Clement Noel, de Franse slalom specialist met explosieve snelheid en technische precisie.",
        "ar": "ملف كليمون نويل، متخصص التعرج الفرنسي بالسرعة المتفجرة والدقة التقنية.",
        "ja": "爆発的なスピードと技術的な精度を持つフランスのスラロームスペシャリスト、クレマン・ノエルのプロフィール。",
        "zh": "Clement Noel de jianjie, yongyou baofaxing sudu he jishu jingzhun de Faguo huixuan zhuanjia.",
        "ko": "폭발적인 스피드와 기술적 정밀함을 가진 프랑스의 슬랄롬 스페셜리스트 클레망 노엘의 프로필."
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
    'clement-noel-alpine-skiing-profile',
    'featured',
    'Clement Noel carving through slalom gates, French team colors, snow spray',
    'pending'
) ON CONFLICT (article_slug, image_type) DO NOTHING;
