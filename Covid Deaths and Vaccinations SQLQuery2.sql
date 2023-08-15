Select*
From PortfolioProject.dbo.['Covid Deaths$']
order by 3,4

Select*
From PortfolioProject.dbo.['Covid Vaccinations$']
order by 3,4



--Select Data that we are going to be using
Select Location,date, total_cases, new_cases,total_deaths,population
From PortfolioProject.dbo.['Covid Deaths$']
order by 1,2

---Changing  Data Type
Select*
From PortfolioProject.dbo.['Covid Deaths$']
Exec sp_help PortfolioProject
ALTER TABLE PortfolioProject.dbo.['Covid Deaths$']
ALTER COLUMN total_deaths INT
ALTER TABLE PortfolioProject.dbo.['Covid Deaths$']
ALTER COLUMN total_cases INT
ALTER TABLE PortfolioProject.dbo.['Covid Deaths$']
ALTER COLUMN new_deaths INT
ALTER TABLE PortfolioProject.dbo.['Covid Vaccinations1$']
ALTER COLUMN new_vaccinations INT





---Looking at Total Cases vs Total Deaths
Select Location,date,total_cases,total_deaths,(total_deaths*1.0/total_cases)*100 as DeathPercentange
From PortfolioProject.dbo.['Covid Deaths$']
order by 1,2

---Looking at countries with highest infection rate compared to population
Select Location,Population,MAX(total_cases)as HighestInfectionCount,Max(total_cases/population*1.0/total_cases)*100 as PercentPopulationInfected
From PortfolioProject.dbo.['Covid Deaths$']
---where location like '%States%'
Group by location,population
order by PercentPopulationInfected desc

---Showing countries with highest death count per population
Select Location,MAX(total_deaths)as TotalDeathCount
From PortfolioProject.dbo.['Covid Deaths$']
---where location like '%States%'
where continent is not null
Group by location
order by TotalDeathCount desc

--LET'S BREAK THINGS DOWN BY CONTINENT
Select continent,MAX(total_deaths)as TotalDeathCount
From PortfolioProject.dbo.['Covid Deaths$']
---where location like '%States%'
where continent is not null
Group by Continent
order by TotalDeathCount desc

---Global Numbers
Select date,SUM(new_cases),SUM(new_deaths)---total_deaths,(total_deaths/total_cases)*100
From PortfolioProject.dbo.['Covid Deaths$']
---where location like '%States%'
where continent is not null
Group by date
order by 1,2

--Looking at Total Population vs Vaccinations

Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
From PortfolioProject.dbo.['Covid Deaths$'] dea
Join PortfolioProject.dbo.['Covid Vaccinations1$'] Vac
 on dea.location=vac.location
 and dea.date=vac.date
 where dea.continent is not null
 order by 2,3

 Drop Table if exists #PercentPopulationVaccinated
 Create Table #PercentPopulationVaccinated
 (
 Continent nvarchar (255),
 Location nvarchar(255),
 Date datetime,
 Population numeric,
 New_vaccinations numeric, 
 RollingPeopleVaccinated numeric
 )
 Insert into #PercentPopulationVaccinated
 Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(CONVERT(numeric,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
From PortfolioProject.dbo.['Covid Deaths$'] dea
Join PortfolioProject.dbo.['Covid Vaccinations1$'] Vac
 on dea.location=vac.location
 and dea.date=vac.date
 where dea.continent is not null
 order by 2,3



