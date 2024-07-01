/*
 Navicat Premium Data Transfer

 Source Server         : frp-era.top
 Source Server Type    : MySQL
 Source Server Version : 80037
 Source Host           : frp-era.top:60481
 Source Schema         : actix-web-blog

 Target Server Type    : MySQL
 Target Server Version : 80037
 File Encoding         : 65001

 Date: 23/06/2024 12:09:11
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for blog_article
-- ----------------------------
DROP TABLE IF EXISTS `blog_article`;
CREATE TABLE `blog_article`  (
  `id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `content` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `user_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `target` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `created_at` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `updated_at` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of blog_article
-- ----------------------------
INSERT INTO `blog_article` VALUES ('101', 'test1', '00 开篇词 这一次，我们从“丑”代码出发\r\n　　开篇词 这一次，我们从“丑”代码出发## 开篇词 这一次，我们从“丑”代码出发\r\n\r\n　　你好，我是郑晔！我又回来了！\r\n\r\n　　我在“极客时间”里已经写了两个专栏，分别是《[10x 程序员工作法]》和《[软件设计之美]》，从工作原则和设计原则两个方面对软件开发的各种知识进行了探讨，帮助你搭建了一个开启程序员精进之路的框架。\r\n\r\n　　不过，无论懂得多少道理，程序员依然要回归到写代码的本职工作上。所以，这次我准备和你从代码的坏味道出发，一起探讨如何写代码。\r\n\r\n千里之堤毁于蚁穴\r\n　　为什么要讲这个话题，就让我们先从一次代码评审讲起。在一次代码评审中，我注意到了这样一段代码：\r\n\r\n　　public void approve(final long bookId) {\r\n　　  ...\r\n　　  book.setReviewStatus(ReviewStatus.APPROVED);\r\n　　  ...\r\n　　}\r\n　　这是在一个服务类里面写的，它的主要逻辑就是从仓库中找出一个作品，然后，将它的状态设置为审核通过，再将它存回去。前后的代码都属于常规的代码，但是，设置作品评审状态的代码引起了我的注意，于是有了下面这段对话。\r\n\r\n　　我：这个地方为什么要这么写？\r\n\r\n　　同事：我要将作品的审核状态设置为审核通过。\r\n\r\n　　我：这个我知道，但为什么要在这里写 setter 呢？\r\n\r\n　　同事：你的意思是？\r\n\r\n　　我：这个审核的状态是作品的一个内部状态，为什么服务需要知道它呢？也就是说，这里通过 setter，将一个类的内部行为暴露了出来，这是一种破坏封装的做法。\r\n\r\n　　同事被我说动了，于是这段代码变成了下面这个样子：\r\n\r\n　　public void approve(final long bookId) {\r\n　　  ...\r\n　　  book.approve();\r\n　　  ...\r\n　　}\r\n　　之所以我注意到这段代码，完全是因为这里用到了 setter。在我看来，setter 就是一个坏味道，每次一看到 setter，我就会警觉起来。\r\n\r\n　　setter 的出现，是对于封装的破坏，它把一个类内部的实现细节暴露了出来。我在《软件设计之美》中讲过，面向对象的封装，关键点是行为，而使用 setter 多半只是做了数据的聚合，缺少了行为的设计，这段代码改写后的 approve 函数，就是这里缺少的行为。\r\n\r\n　　再扩展一步，setter 通常还意味着变化，而我在《软件设计之美》中讲函数式编程时也说过，一个好的设计应该尽可能追求不变性。所以，setter 也是一个提示符，告诉我们，这个地方的设计可能有问题。\r\n\r\n　　你看，一个小小的 setter，背后却隐藏着这么多的问题。而所有这些问题，都会让代码在未来的日子变得更加不可维护，这就是软件团队陷入泥潭的开始。\r\n\r\n　　我也一直和我团队的同学说，“写代码”有两个维度：正确性和可维护性，不要只关注正确性。能把代码写对，是每个程序员的必备技能，但能够把代码写得更具可维护性，这是一个程序员从业余迈向职业的第一步。\r\n\r\n将坏味道重构为整洁代码\r\n　　或许你也认同代码要有可维护性，也看了很多书，比如《程序设计实践》《代码整洁之道》等等，这些无一不是经典中的经典，甚至连怎么改代码，都有《重构》等着我们。没错，这些书我都读过，也觉得从中受益匪浅。\r\n\r\n　　不过，回到真实的工作中，我发现了一个无情的事实：程序员们大多会认同这些书上的观点，但每个人对于这些观点的理解却是千差万别的。\r\n\r\n　　比如书上说：“命名是要有意义的”，但什么样的命名才算是有意义的呢？有的人只理解到不用 xyz 命名，虽然他起出了自认为“有意义”的名字，但这些名字依然是难以理解的。事实上，大部分程序员在真实世界中面对的代码，就是这样难懂的代码。\r\n\r\n　　这是因为，很多人虽然知道正面的代码是什么样子，却不知道反面的代码是什么样子。这些反面代码，Martin Fowler 在《重构》这本书中给起了一个好名字，代码的坏味道（Bad Smell）。\r\n\r\n　　在我写代码的这 20 多年里，一直对代码的坏味道非常看重，因为它是写出好代码的起点。有对代码坏味道的嗅觉，能够识别出坏味道，接下来，你才有机会去“重构（Refactoring）”，把代码一点点打磨成一个整洁的代码（Clean Code）。Linux 内核开发者 Linus Torvalds 在行业里有个爱骂人的坏名声，原因之一就是他对于坏味道的不容忍。\r\n\r\n　　所以，我也推荐那些想要提高自己编程水平的人读《重构》，如果时间比较少，就去读第三章“代码的坏味道”。\r\n\r\n　　不过，《重构》中的“代码的坏味道”意图虽好，但却需要一个人对于整洁代码有着深厚的理解，才能识别出这些坏味道。否则，即使你知道有哪些坏味道，但真正有坏味道的代码出现在你面前时，你仍然无法认得它。\r\n\r\n　　比如，你可以看看 Info、Data、Manager 是不是代码库经常使用的词汇，而它们往往是命名没有经过仔细思考的地方。在很多人眼中，这些代码是没有问题的。正因如此，才有很多坏味道的代码才堂而皇之地留在你的眼皮底下。\r\n\r\n　　所以，我才想做一个讲坏味道的专栏，把最常见的坏味道直接用代码形式展现出来。在这个专栏里，我给你的都是即学即用的“坏味道”，我不仅会告诉你典型的坏味道是什么，而且也能让你在实际的编程过程中发现它们。比如前面那个例子里面的 setter，只要它一出现，你就需要立即警觉起来。', '01', 'rust,cpp,c,java', '2024-06-21 10:42:22', '2024-06-21 10:42:25');
INSERT INTO `blog_article` VALUES ('102', 'test2', 'test', '01', 'rust,cpp,c,java', '2024-06-21 10:42:22', '2024-06-21 10:42:25');
INSERT INTO `blog_article` VALUES ('103', 'test3', 'test', '01', 'rust,cpp,c,java', '2024-06-21 10:42:22', '2024-06-21 10:42:25');
INSERT INTO `blog_article` VALUES ('104', 'test4', 'test', '01', 'rust,cpp,c,java', '2024-06-21 10:42:22', '2024-06-21 10:42:25');
-- ----------------------------
-- Table structure for blog_user
-- ----------------------------
DROP TABLE IF EXISTS `blog_user`;
CREATE TABLE `blog_user`  (
  `id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `username` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `email` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `bio` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL,
  `is_login` varchar(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of blog_user
-- ----------------------------
INSERT INTO `blog_user` VALUES ('01', 'MenghanStudio', 'root', '1756524586@qq.com', 'LIshuo@root123', 'test', '0');

SET FOREIGN_KEY_CHECKS = 1;
