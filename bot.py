import discord
from discord.ext import commands
import json
import os

# قراءة ملف التكوين
if os.path.exists("config.json"):
    with open("config.json", "r", encoding="utf-8") as f:
        config = json.load(f)
else:
    print("❌ خطأ: ملف config.json غير موجود!")
    exit()

TOKEN = config["token"]
LOG_CHANNEL_ID = config.get("log_channel_id", 0)

intents = discord.Intents.default()
intents.message_content = True
intents.guilds = True
intents.members = True

class UniversalBot(commands.Bot):
    def __init__(self):
        super().__init__(command_prefix="!", intents=intents)

    async def setup_hook(self):
        # مزامنة أوامر السلاش (/) تلقائياً مع ديسكورد
        await self.tree.sync()
        print("⚡ تم تفعيل ومزامنة جميع أوامر المساعد الذكي بنجاح!")

bot = UniversalBot()

@bot.event
async def on_ready():
    print(f"🤖 بوت المساعدات جاهز ويعمل باسم: {bot.user}")
    await bot.change_presence(activity=discord.Activity(type=discord.ActivityType.watching, name="خدمة السيرفرات | /help"))

# --- 1. أمر المساعدة العام (Help) ---
@bot.tree.command(name="help", description="عرض قائمة أوامر المساعد الذكي ومميزاته")
async def help_command(interaction: discord.Interaction):
    embed = discord.Embed(
        title="🤖 لوحة تحكم المساعد الذكي للسيرفرات",
        description="أهلاً بك! أنا بوت مساعد متعدد الاستخدامات مصمم خصيصاً لتنظيم ومساعدة سيرفرات ديسكورد باحترافية.",
        color=discord.Color.blurple()
    )
    embed.add_field(name="⚙️ الأوامر المتاحة:", value="`/ping` - فحص سرعة استجابة البوت\n`/serverinfo` - عرض معلومات السيرفر الحالي\n`/userinfo` - عرض معلومات عضويتك أو أي عضو\n`/clear` - مسح الرسائل بسرعة وسهولة", inline=False)
    embed.set_footer(text="المساعد الرسمي • جاهز لخدمة سيرفرك 24/7")
    await interaction.response.send_message(embed=embed, ephemeral=True)

# --- 2. أمر فحص البينج (Ping) ---
@bot.tree.command(name="ping", description="فحص سرعة استجابة البوت وسرعة السيرفر")
async def ping(interaction: discord.Interaction):
    latency = round(bot.latency * 1000)
    embed = discord.Embed(
        title="🏓 Pong!",
        description=f"سرعة استجابة البوت الحالية: **{latency}ms** ⚡",
        color=discord.Color.green()
    )
    await interaction.response.send_message(embed=embed)

# --- 3. أمر معلومات السيرفر (Server Info) ---
@bot.tree.command(name="serverinfo", description="عرض معلومات وإحصائيات السيرفر الحالي")
async def serverinfo(interaction: discord.Interaction):
    guild = interaction.guild
    embed = discord.Embed(
        title=f"📊 إحصائيات سيرفر: {guild.name}",
        color=discord.Color.gold()
    )
    if guild.icon:
        embed.set_thumbnail(url=guild.icon.url)
    
    embed.add_field(name="👑 المالك:", value=guild.owner.mention if guild.owner else "غير متوفر", inline=True)
    embed.add_field(name="👥 عدد الأعضاء:", value=f"{guild.member_count} عضو", inline=True)
    embed.add_field(name="📅 تاريخ الإنشاء:", value=guild.created_at.strftime("%Y/%m/%d"), inline=True)
    embed.add_field(name="💬 الرومات:", value=f"تكتيكية/نصية: {len(guild.text_channels)} | صوتية: {len(guild.voice_channels)}", inline=False)
    
    await interaction.response.send_message(embed=embed)

# --- 4. أمر مسح الرسائل للإدارة (Clear) ---
@bot.tree.command(name="clear", description="مسح عدد محدد من الرسائل في الروم")
@discord.app_commands.describe(amount="عدد الرسائل المراد مسحها (من 1 إلى 100)")
@discord.app_commands.checks.has_permissions(manage_messages=True)
async def clear(interaction: discord.Interaction, amount: int):
    if amount < 1 or amount > 100:
        return await interaction.response.send_message("❌ يرجى تحديد عدد رسائل بين 1 و 100 فقط.", ephemeral=True)
    
    await interaction.response.defer(ephemeral=True)
    deleted = await interaction.channel.purge(limit=amount)
    await interaction.followup.send(f"🧹 تم بنجاح مسح **{len(deleted)}** رسالة من هذا الروم.", ephemeral=True)

# تشغيل البوت
bot.run(TOKEN)
