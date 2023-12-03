from discrete_normal import DiscreteNormal as DN

dist = DN(mean=50, sd=10, cutoff_distance=30)
pdf = dist.complete_pdf()

df = dist.histogram()
